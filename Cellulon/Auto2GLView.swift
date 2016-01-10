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
    var reverse = false
    var first = true
    
    var displayLink: CADisplayLink!
    
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
            TexCoord(tuple: (0.0, 1.0)),
            TexCoord(tuple: (1.0, 1.0)),
            TexCoord(tuple: (1.0, 0.0)),
            TexCoord(tuple: (0.0, 0.0)),
        ]
        return TexCoordBuffer(elements: elements)
    }
    
    var glLayer: CAEAGLLayer {
        return layer as! CAEAGLLayer
    }
    
    var pixelSize: CGSize {
        return bounds.size * UIScreen.mainScreen().scale
    }
    
    override class func layerClass() -> AnyClass {
        return CAEAGLLayer.self
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        srandom(UInt32(time(nil)))

        prepareGL()
        displayLink = CADisplayLink(target: self, selector: "update")
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        displayLink.paused = false
        displayLink.frameInterval = 2
    }
    
    func prepareGL() {
        // this must happen first
        prepareContext()
        
        // these can happen in any order
        prepareDrawable()
        prepareTextureFramebuffer()
//        prepareRendererState()
        prepareShaders()
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
        
        // TODO: we are loading the textures wrong when they have no data
        // for now, use some test images (which will never be drawn unless there is a bug)

//        let texture0 = Texture(size: CGSize(width: 256, height: 256), data: nil)
        let texture0 = Texture.textureWithName("David med", filetype: "png")!
        texture0.setParameter(GLint(GL_TEXTURE_MAG_FILTER), value: GLint(GL_NEAREST))
        
//        let texture1 = Texture(size: CGSize(width: 256, height: 256), data: nil)
        let texture1 = Texture.textureWithName("grey brick 256", filetype: "jpg")!
        texture1.setParameter(GLint(GL_TEXTURE_MAG_FILTER), value: GLint(GL_NEAREST))
        
        textures.append(texture0)
        textures.append(texture1)
    }
    
    func prepareShaders() {
        program = Program()
        
        program.use()
        let matrix = GLKMatrix4Identity
        glUniformMatrix4fv(program.getLocationOfUniform("MVP"), 1, GLboolean(GL_FALSE), matrix.toArray())

        textureProg = Program.newProgramWithName("Conway")
    }
    
    func prepareContent() {
        pointBuffer = makePoints()
        texCoordBuffer = makeTexCoords()
    }
    
    func prepareRendererState() {
        setCenteredViewport(4.0)
    }
    
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
    
    func update() {
        
        let source = textures[ reverse ? 1 : 0 ]
        let dest = textures[ reverse ? 0 : 1 ]

        let fb1 = Framebuffer()
        fb1.setColorAttachment(source, atIndex: 0)
        
        let fb2 = Framebuffer()
        fb2.setColorAttachment(dest, atIndex: 0)
        
        fb1.bind(true)
        fb2.bind(false)
        
        glViewport(0, 0, 256, 256)
        
        if reverse {
            glClearColor(0, 0, 0.5, 1)
        }
        else {
            glClearColor(0, 0.5, 0, 1)
        }
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        textureProg.use()
        if first {
            textureProg.submitUniform(GLint(1), uniformName: "initRandom")
            let seed1 = GLfloat(random())/GLfloat(INT_MAX)
            let seed2 = GLfloat(random())/GLfloat(INT_MAX)
            glUniform2f(textureProg.getLocationOfUniform("seed"), seed1, seed2)
        }
        textureProg.submitTexture(source, uniformName: "sampler")
        textureProg.submitBuffer(pointBuffer, name: "position")
        textureProg.submitBuffer(texCoordBuffer, name: "texCoord")
        
        glDrawArrays(GLenum(GL_TRIANGLE_FAN), 0, pointBuffer.count)
        glFinish()

        if first {
            textureProg.submitUniform(GLint(0), uniformName: "initRandom")
            first = false
        }
        
        render()

        reverse = !reverse
    }
    
    func render() {
    
        framebuffer.bind()

        prepareRendererState()

        glClearColor(0.5, 0, 0, 1)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT))
        
        // TODO: use blitting instead of rendering textured triangles
        
        program.use()
        program.submitUniform(GLuint(GL_TRUE), uniformName: "useTex")
        program.submitTexture(textures[1], uniformName: "sampler")
        program.submitBuffer(pointBuffer, name: "position")
        program.submitBuffer(texCoordBuffer, name: "texCoord")

        glDrawArrays(GLenum(GL_TRIANGLE_FAN), 0, pointBuffer.count)
        
        self.context.presentRenderbuffer(Int(GL_FRAMEBUFFER))
    }
}
