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
    var framebuffer: Framebuffer!

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
        prepareGL()
        render()
    }
    
    func prepareGL() {
        // this must happen first
        prepareContext()
        
        // these can happen in any order
        prepareDrawable()
        prepareRendererState()
        prepareShaders()
        prepareContent()
    }
    
    func prepareContext() {
        context = EAGLContext(API: .OpenGLES3)
        EAGLContext.setCurrentContext(context)
    }
    
    func prepareDrawable() {
        // These lines must happen in this exact order
        let colorBuffer = Renderbuffer()
        context.renderbufferStorage(colorBuffer, fromDrawable: glLayer)
        framebuffer = Framebuffer()
        framebuffer.colorAttachment0 = colorBuffer
    }
    
    func prepareShaders() {
        program = Program.newProgramWithName("Conway")
    }
    
    func prepareContent() {
        pointBuffer = makePoints()
    }
    
    func prepareRendererState() {
        let size = bounds.size
        glViewport(0, 0, GLsizei(size.width), GLsizei(size.height))
        glClearColor(0.5, 0, 0, 1)
    }
    
    func render() {
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT))
        program.use()
        program.submitBuffer(pointBuffer, name: "position")
        self.context.presentRenderbuffer(Int(GL_FRAMEBUFFER))
    }
}
