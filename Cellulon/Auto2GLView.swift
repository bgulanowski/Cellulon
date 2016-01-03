//
//  Auto2GLView.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-31.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import UIKit
import Grift

class Auto2GLView: UIView {
    
    var context: EAGLContext!
    
    var frameBuffer: GLuint = 0
    var colorRenderbuffer: GLuint = 0

    var program: Program!
    var pointBuffer: Point2Buffer!

    func makePoints() -> Point2Buffer {
        let elements = [
            Point2(tuple: (-0.5, -0.5)),
            Point2(tuple: ( 0.5, -0.5)),
            Point2(tuple: ( 0.5,  0.5))
        ]
        return Point2Buffer(elements: elements)
    }
    
    var glLayer: CAEAGLLayer {
        return layer as! CAEAGLLayer
    }
    
    override class func layerClass() -> AnyClass {
        return CAEAGLLayer.self
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        glLayer.opaque = true
        
        context = EAGLContext(API: .OpenGLES3)
        EAGLContext.setCurrentContext(context)
        
        glGenRenderbuffers(1, &colorRenderbuffer)
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), colorRenderbuffer)
        
        context.renderbufferStorage(Int(GL_RENDERBUFFER), fromDrawable: glLayer)
        
        glGenFramebuffers(1, &frameBuffer)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffer)
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), colorRenderbuffer)
        
        pointBuffer = makePoints()
        program = Program.newProgramWithName("Conway")
        glClearColor(0.5, 0, 0, 1)
        glDisable(GLenum(GL_CULL_FACE))
        
        let size = bounds.size
        glViewport(0, 0, GLsizei(size.width), GLsizei(size.height))

        render()
    }
    
    func render() {
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT))
        program.use()
        program.submitBuffer(pointBuffer, name: "position")
        self.context.presentRenderbuffer(Int(GL_FRAMEBUFFER))
    }
}
