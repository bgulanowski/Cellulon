//
//  Auto2GLView.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-31.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import UIKit
import Grift
import GLKit

extension GLKMatrix4 {
    func toArray() -> [GLfloat] {
        return [
            self.m00, self.m01, self.m02, self.m03,
            self.m10, self.m11, self.m12, self.m13,
            self.m20, self.m21, self.m22, self.m23,
            self.m30, self.m31, self.m32, self.m33
        ]
    }
}

func *(size: CGSize, factor: CGFloat) -> CGSize {
    return CGSize(width: size.width * factor, height: size.height * factor)
}

class Auto2GLView: UIView {
    
    var context: EAGLContext!
    var framebuffer: Framebuffer!
    var program: Program!
    
    var pointBuffer: Point2Buffer!

    var textures = [Texture]()
    var textureProg: Program!
    var texCoordBuffer: Point2Buffer!
    var texFramebuffer: Framebuffer!
    
    var scale: CGFloat!
    var reverse = false
    var first = true
    
    var displayLink: CADisplayLink!
    
    var glLayer: CAEAGLLayer {
        return layer as! CAEAGLLayer
    }
    
    var pixelSize: CGSize {
        return bounds.size * UIScreen.mainScreen().scale
    }
    
    override class func layerClass() -> AnyClass {
        return CAEAGLLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        srandom(UInt32(time(nil)))
        prepareGestureRecognizers()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if nil == context {
            scale = calculateViewportScale()
            prepareGL()
            prepareDisplayLink()
        }
        
        displayLink.paused = superview == nil
    }
    
    func prepareGestureRecognizers() {
        let oneTap = UITapGestureRecognizer(target: self, action: "toggleAnimation:")
        let twoTap = UITapGestureRecognizer(target: self, action: "saveImage:")
        oneTap.numberOfTapsRequired = 1
        twoTap.numberOfTapsRequired = 2
        oneTap.requireGestureRecognizerToFail(twoTap)
        self.addGestureRecognizer(oneTap)
        self.addGestureRecognizer(twoTap)
    }

    func prepareDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: "update")
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        displayLink.frameInterval = 8
        displayLink.paused = true
    }
    
    // MARK: OpenGL prep
    
    func prepareGL() {
        // this must happen first
        prepareContext()
        
        prepareDrawable()
        prepareTextureFramebuffer()
        prepareShaders()
        
        // shaders must be prepared before content
        prepareContent()
    }
    
    func prepareContext() {
        context = EAGLContext(API: .OpenGLES3)
        EAGLContext.setCurrentContext(context)
    }
    
    func prepareDrawable() {
        glLayer.contentsScale = UIScreen.mainScreen().scale
        let colorBuffer = Renderbuffer()
        context.renderbufferStorage(colorBuffer, fromDrawable: glLayer)
        framebuffer = Framebuffer()
        framebuffer.bind(false)
        framebuffer.setColorAttachment(colorBuffer, atIndex: 0)
    }
    
    func prepareTextureFramebuffer() {
        
        // FIXME: we are loading the textures wrong when they have no data
        // for now, use some test images (which will never be drawn unless there is a bug)

//        let texture0 = Texture(size: CGSize(width: 256, height: 256), data: nil)
//        let texture1 = Texture(size: CGSize(width: 256, height: 256), data: nil)

        let texture0 = Texture.textureWithName("David med", filetype: "png")!
        texture0.setParameter(GLint(GL_TEXTURE_MAG_FILTER), value: GLint(GL_NEAREST))
        
        let texture1 = Texture.textureWithName("grey brick 256", filetype: "jpg")!
        texture1.setParameter(GLint(GL_TEXTURE_MAG_FILTER), value: GLint(GL_NEAREST))
        
        textures.append(texture0)
        textures.append(texture1)
        
        texFramebuffer = Framebuffer()
    }
    
    func prepareShaders() {
        
        program = Program()
        
        program.use()
        let matrix = GLKMatrix4Identity
        // TODO: support for matrix submission in Program class
        glUniformMatrix4fv(program.getLocationOfUniform("MVP"), 1, GLboolean(GL_FALSE), matrix.toArray())

        // We can set these once, because they never change
        program.submitUniform(GLuint(GL_TRUE), uniformName: "useTex")

        textureProg = Program.newProgramWithName("Conway")
        textureProg.use()
        textureProg.submitUniform(GLint(1), uniformName: "initRandom")
        let seed1 = GLfloat(random())/GLfloat(INT_MAX)
        let seed2 = GLfloat(random())/GLfloat(INT_MAX)
        glUniform2f(textureProg.getLocationOfUniform("seed"), seed1, seed2)
    }
    
    func prepareContent() {
        pointBuffer = makePoints()
        texCoordBuffer = makeTexCoords()
        program.submitBuffer(pointBuffer, name: "position")
        program.submitBuffer(texCoordBuffer, name: "texCoord")
    }
    
    // MARK: data model prep
    
    func makePoints() -> Point2Buffer {
        let elements = [
            Point2(tuple: (-1.0, -1.0)),
            Point2(tuple: ( 1.0, -1.0)),
            Point2(tuple: ( 1.0,  1.0)),
            Point2(tuple: (-1.0,  1.0))
        ]
        return Point2Buffer(elements: elements)
    }
    
    func makeTexCoords() -> TexCoordBuffer {
        let elements = [
            TexCoord(tuple: (0.0, 0.0)),
            TexCoord(tuple: (1.0, 0.0)),
            TexCoord(tuple: (1.0, 1.0)),
            TexCoord(tuple: (0.0, 1.0)),
        ]
        return TexCoordBuffer(elements: elements)
    }
    
    // MARK: Viewport conveniences
    
    func setCenteredViewport(scale: CGFloat) {
        let size = pixelSize
        let x = GLint((size.width - 256.0 * scale) / 2.0)
        let y = GLint((size.height - 256.0 * scale) / 2.0)
        glViewport(x, y, 256 * GLint(scale), 256 * GLint(scale))
    }
    
    func logCurrentViewport() {
        var viewport: [GLint] = [0, 0, 0, 0]
        viewport.withUnsafeMutableBufferPointer({ (inout p: UnsafeMutableBufferPointer<Int32>) in
            glGetIntegerv(GLenum(GL_VIEWPORT), p.baseAddress)
        })
        print("existing viewport: \(viewport)")
    }
    
    func calculateViewportScale() -> CGFloat {
        var scale = 1
        let size = pixelSize
        let minLen = Int(min(size.width, size.height))
        while scale * 256 < minLen {
            ++scale
        }
        return CGFloat(scale)
    }
    
    // MARK: Transformation Matrix Utilities
    // These matrices are only useful if the viewport of the presentation layer is the size of the screen
    func makeProportionalMatrix() -> GLKMatrix4 {
        let size = bounds.size
        let aspect = Float(size.height/size.width)
        return GLKMatrix4Scale(GLKMatrix4Identity, 1.0, aspect, 1.0)
    }
    
    func makeSizedMatrix() -> GLKMatrix4 {
        let size = bounds.size
        let scaleX = 256.0 / Float(size.width)
        let scaleY = 256.0 / Float(size.height)
        return GLKMatrix4Scale(GLKMatrix4Identity, scaleX, scaleY, 1.0)
    }
    
    // MARK: updates
    
    func updateRendererState() {
        setCenteredViewport(CGFloat(scale))
    }
    
    func update() {
        
        let source = textures[ reverse ? 1 : 0 ]
        let dest = textures[ reverse ? 0 : 1 ]

        texFramebuffer.setColorAttachment(dest, atIndex: 0)
        texFramebuffer.bind()
        
        glViewport(0, 0, 256, 256)
        
        // This is useful if the shader breaks, but need to still confirm texture swapping works
//        if reverse {
//            glClearColor(0, 0, 0.5, 1)
//        }
//        else {
//            glClearColor(0, 0.5, 0, 1)
//        }
//        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        textureProg.use()
        textureProg.submitTexture(source, uniformName: "sampler")
        textureProg.submitBuffer(pointBuffer, name: "position")
        textureProg.submitBuffer(texCoordBuffer, name: "texCoord")
        
        glDrawArrays(GLenum(GL_TRIANGLE_FAN), 0, pointBuffer.count)
        glFinish()

        if first {
            textureProg.submitUniform(GLint(0), uniformName: "initRandom")
            first = false
        }
        
        reverse = !reverse
        
        render()
    }
    
    func render() {
    
        framebuffer.bind()

        updateRendererState()

        glClearColor(0.0, 0, 0, 1)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT))
        
        // TODO: use blitting instead of rendering textured triangles
        
        program.use()
        program.submitTexture(textures[reverse ? 1 : 0], uniformName: "sampler")

        glDrawArrays(GLenum(GL_TRIANGLE_FAN), 0, pointBuffer.count)
        
        self.context.presentRenderbuffer(Int(GL_FRAMEBUFFER))
    }
    
    // MARK: actions
    
    func toggleAnimation(sender: UITapGestureRecognizer) {
        displayLink.paused = !displayLink.paused
    }
    
    func saveImage(sender: UITapGestureRecognizer) {
        let wasPaused = displayLink.paused
        displayLink.paused = true
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0)
        self.drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let url = NSURL(fileURLWithPath: path.first!).URLByAppendingPathComponent("Conway \(NSDate())")
        
        UIImagePNGRepresentation(image)?.writeToURL(url, atomically: true)
        print("saved image to file \(url)")
        
//        texFramebuffer.bind(true)
//        var pixels = malloc(256 * 256 * 4)
//        glReadPixels(0, 0, 256, 256, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), pixels)
//        UIImage(data: NSData()
        
        self.snapshotViewAfterScreenUpdates(true)
        
        displayLink.paused = wasPaused
    }
}
