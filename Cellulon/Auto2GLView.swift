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
    var textureProg: Program!
    var texCoordBuffer: Point2Buffer!
    var reverse = true
    
    var displayLink: CADisplayLink!
    
    func makePoints() -> Point2Buffer {
        let elements = [
            Point2(tuple: (-0.75, -0.75)),
            Point2(tuple: ( 0.75, -0.75)),
            Point2(tuple: ( 0.75,  0.75)),
            Point2(tuple: (-0.75,  0.75))
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
    
    override class func layerClass() -> AnyClass {
        return CAEAGLLayer.self
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        prepareGL()
        displayLink = CADisplayLink(target: self, selector: "update")
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        displayLink.paused = false
        displayLink.frameInterval = 60
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
        let colorBuffer = Renderbuffer()
        context.renderbufferStorage(colorBuffer, fromDrawable: glLayer)
        framebuffer = Framebuffer()
        framebuffer.bind(false)
        framebuffer.setColorAttachment(colorBuffer, atIndex: 0)
    }
    
    func prepareTextureFramebuffer() {

//        let texture0 = Texture(size: CGSize(width: 256, height: 256), data: nil)
        let texture0 = Texture.textureWithName("David med", filetype: "png")!
//        let texture1 = Texture(size: CGSize(width: 256, height: 256), data: nil)
        let texture1 = Texture.textureWithName("grey brick 256", filetype: "jpg")!
        
        textures.append(texture0)
        textures.append(texture1)
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
    }
    
    func update() {
        
        let source = textures[ reverse ? 1 : 0 ]
        let dest = textures[ reverse ? 0 : 1 ]
        
        prepareRendererState()
        render(source)

        let fb1 = Framebuffer()
        fb1.setColorAttachment(source, atIndex: 0)
        
        let fb2 = Framebuffer()
        fb2.setColorAttachment(dest, atIndex: 0)
        
        fb1.bind(true)
//        fb1.bind(false)
        
        glViewport(0, 0, 256, 256)
        
        if reverse {
            glClearColor(0, 0, 0.5, 1)
        }
        else {
            glClearColor(0, 0.5, 0, 1)
        }
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        textureProg.use()
        textureProg.submitTexture(source, uniformName: "sampler")
        textureProg.submitBuffer(pointBuffer, name: "position")
        textureProg.submitBuffer(texCoordBuffer, name: "texCoord")
        
        glDrawArrays(GLenum(GL_TRIANGLE_FAN), 0, pointBuffer.count)

        reverse = !reverse
    }
    
    func render(texture: Texture) {
    
        framebuffer.bind()
        glClearColor(0.5, 0, 0, 1)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT))
        
        program.use()
        
        // TODO: support for matrices in Program.submitUniformMatrix
        let matrix = Array<GLfloat>( arrayLiteral:
            1.0, 0.0, 0.0, 0.0,
            0.0, 1.0, 0.0, 0.0,
            0.0, 0.0, 1.0, 0.0,
            0.0, 0.0, 0.0, 1.0
        )
        
        // TODO: use blitting instead of rendering textured triangles
        
        glUniformMatrix4fv(program.getLocationOfUniform("MVP"), 1, GLboolean(GL_FALSE), matrix)

        program.submitUniform(GLuint(GL_TRUE), uniformName: "useTex")
        program.submitTexture(texture, uniformName: "sampler")
        program.submitBuffer(pointBuffer, name: "position")
        program.submitBuffer(texCoordBuffer, name: "texCoord")

        glDrawArrays(GLenum(GL_TRIANGLE_FAN), 0, pointBuffer.count)

//        glInsertEventMarkerEXT(0, "com.apple.GPUTools.event.debug-frame")
        
        self.context.presentRenderbuffer(Int(GL_FRAMEBUFFER))
    }
}
