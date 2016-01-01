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
    var program: Program!
//    var texture: Texture!
//    var framebuffer: Framebuffer!
    var pointBuffer: Point2Buffer!
    
    func makePoints() -> Point2Buffer {
        let elements = [
            Point2(tuple: (0, 0)),
            Point2(tuple: (1, 0)),
            Point2(tuple: (0, 1)),
            Point2(tuple: (1, 1))
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
        
        context = EAGLContext(API: .OpenGLES3)
        context.renderbufferStorage(Int(GL_RENDERBUFFER), fromDrawable: glLayer)
        EAGLContext.setCurrentContext(context)
        
        pointBuffer = makePoints()
        program = Program.newProgramWithName("Conway")
        
//        glViewport(0, 0, GLsizei(bounds.size.width), GLsizei(bounds.size.height))
        glViewport(0, 0, 1, 1)
        render()
    }
    
    func render() {
        program.use()
        pointBuffer.bind()
        program.enableBuffer(pointBuffer, name: "")
        self.context.presentRenderbuffer(Int(GL_FRAMEBUFFER))
    }
}
