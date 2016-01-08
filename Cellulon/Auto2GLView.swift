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

class Auto2GLView: UIView {
    
    var context: EAGLContext!
    var framebuffer: Framebuffer!
    var program: Program!
    
    var pointBuffer: Point2Buffer!
    var textures = [Texture]()

    var textureFB: Framebuffer!
    var textureProg: Program!
    var texCoordBuffer: Point2Buffer!
    var reverse = false
    
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
            TexCoord(tuple: (0.0, 0.0)),
            TexCoord(tuple: (0.0, 1.0)),
            TexCoord(tuple: (1.0, 1.0)),
            TexCoord(tuple: (1.0, 0.0)),
        ]
        return TexCoordBuffer(elements: elements)
    }
    
    var glLayer: CAEAGLLayer {
        return layer as! CAEAGLLayer
    }
    
    override class func layerClass() -> AnyClass {
        return CAEAGLLayer.self
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        prepareGL()
        displayLink = CADisplayLink(target: self, selector: "render")
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        displayLink.paused = false
        displayLink.frameInterval = 15
//        render()
    }
    
    func prepareGL() {
        // this must happen first
        prepareContext()
        
        // these can happen in any order
        prepareDrawable()
        prepareTextureFramebuffer()
        prepareRendererState()
        prepareShaders()
        prepareContent()
    }
    
    func prepareContext() {
        context = EAGLContext(API: .OpenGLES3)
        EAGLContext.setCurrentContext(context)
    }
    
    func prepareDrawable() {
        let colorBuffer = Renderbuffer()
        // renderbuffer storage must be allocated before it is attached to the framebuffer
        context.renderbufferStorage(colorBuffer, fromDrawable: glLayer)
        framebuffer = Framebuffer()
        framebuffer.setColorAttachment(colorBuffer, atIndex: 0)
    }
    
    func prepareTextureFramebuffer() {
        textureFB = Framebuffer()
//        let texture0 = Texture(size: CGSize(width: 256, height: 256), data: nil)
        let texture0 = Texture.textureWithName("David med", filetype: "png")
        let texture1 = Texture(size: CGSize(width: 256, height: 256), data: nil)
        textureFB.setColorAttachment(texture0, atIndex: 0)
        textureFB.setColorAttachment(texture1, atIndex: 1)
        if glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER)) != GLenum(GL_FRAMEBUFFER_COMPLETE) {
            print("texture framebuffer is not complete")
        }
    }
    
    func prepareShaders() {
        program = Program()
        textureProg = Program.newProgramWithName("Conway")
    }
    
    func prepareContent() {
        pointBuffer = makePoints()
        texCoordBuffer = makeTexCoords()
    }
    
    func prepareRendererState() {
        let size = bounds.size
        glViewport(0, 0, GLsizei(size.width), GLsizei(size.height))
        glClearColor(0.5, 0, 0, 1)
    }
    
    func update() {
        
        textureFB.bind()
        var drawBuffer = GLenum(reverse ? GL_COLOR_ATTACHMENT0 : GL_COLOR_ATTACHMENT1)
        glDrawBuffers(1, &drawBuffer)
        
        textureProg.use()
        let texture = textureFB.colorAttachmentAtIndex(reverse ? 1 : 0)

        textureProg.submitTexture(texture as! Texture, uniformName: "sampler")
        textureProg.submitBuffer(pointBuffer, name: "position")
        textureProg.submitBuffer(texCoordBuffer, name: "texCoord")
        
        glDrawArrays(GLenum(GL_TRIANGLE_FAN), 0, pointBuffer.count)
        glFinish()

        reverse = !reverse
    }
    
    func render() {
        
        framebuffer.bind()
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT))
        
        program.use()
        
        // TODO: support for matrices in Program.submitUniformMatrix
        let matrix = Array<GLfloat>( arrayLiteral:
            1.0, 0.0, 0.0, 0.0,
            0.0, 1.0, 0.0, 0.0,
            0.0, 0.0, 1.0, 0.0,
            0.0, 0.0, 0.0, 1.0
        )
        
        glUniformMatrix4fv(program.getLocationOfUniform("MVP"), 1, GLboolean(GL_FALSE), matrix)

        let texture = textureFB.colorAttachmentAtIndex(reverse ? 1 : 0)
        program.submitUniform(GLuint(GL_TRUE), uniformName: "useTex")
        program.submitTexture(texture as! Texture, uniformName: "sampler")
        program.submitBuffer(pointBuffer, name: "position")
        program.submitBuffer(texCoordBuffer, name: "texCoord")

        glDrawArrays(GLenum(GL_TRIANGLE_FAN), 0, pointBuffer.count)

        self.context.presentRenderbuffer(Int(GL_FRAMEBUFFER))
        
        update()
    }
}
