//
//  MetalView.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-30.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import UIKit
import QuartzCore

class MetalView: UIView {

#if arch(arm) || arch(arm64)
    let vertexData:[Float] = [
        +0.0, +1.0, +0.0,
        -1.0, -1.0, +0.0,
        +1.0, -1.0, +0.0]
    
    var vertexBuffer:  MTLBuffer! = nil
    var pipelineState: MTLRenderPipelineState! = nil
    var commandQueue: MTLCommandQueue! = nil
    var displayLink: CADisplayLink! = nil

    var metalLayer: CAMetalLayer {
        return layer as! CAMetalLayer
    }
    
    override class func layerClass() -> AnyClass {
        return CAMetalLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if prepareRenderer() {
//            enableDisplayLink()
        }
    }
    
    func prepareRenderer() -> Bool {
        if let device = MTLCreateSystemDefaultDevice() {
            prepareVertexDataWithDevice(device)
            prepareLayerWithDevice(device)
            buildPipelineWithDevice(device)
            commandQueue = device.newCommandQueue()
            return true
        }
        else {
            return false
        }
    }
    
    func enableDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: "render")
        displayLink.paused = true
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    override func didMoveToSuperview() {
//        displayLink.paused = superview == nil
        metalLayer.drawableSize = self.bounds.size
        render()
    }
    
    func buildPipelineWithDevice(device: MTLDevice) {
        if let defaultLibrary = device.newDefaultLibrary() {
            do {
                try pipelineState = device.newRenderPipelineStateWithDescriptor(pipelineDescriptorWithLibrary(defaultLibrary))
            }
            catch {
                print("\(error)")
            }
        }
        else {
            print("unable to create default library")
        }
    }
    
    func prepareVertexDataWithDevice(device: MTLDevice) {
        let dataSize = vertexData.count * sizeofValue(vertexData[0])
        vertexBuffer = device.newBufferWithBytes(vertexData, length: dataSize, options: .CPUCacheModeDefaultCache)
    }
    
    func prepareLayerWithDevice(device: MTLDevice) {
        let layer = metalLayer
        layer.device = device
        layer.pixelFormat = .BGRA8Unorm
        layer.framebufferOnly = true
    }
    
    func pipelineDescriptorWithLibrary(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = library.newFunctionWithName("basic_vertex")
        descriptor.fragmentFunction = library.newFunctionWithName("basic_fragment")
        descriptor.colorAttachments[0].pixelFormat = .BGRA8Unorm
        return descriptor
    }
    
    func render() {
        autoreleasepool {
            if let drawable = metalLayer.nextDrawable() {
                let renderPass = MTLRenderPassDescriptor()
                let attachment = renderPass.colorAttachments[0]
                attachment.texture = drawable.texture
                attachment.loadAction = .Clear
                attachment.clearColor = MTLClearColorMake(0.0, 104.0/255.0, 5.0/255.0, 1.0)
                
                let commandBuffer = commandQueue.commandBuffer()
                let render = commandBuffer.renderCommandEncoderWithDescriptor(renderPass)
                render.setRenderPipelineState(pipelineState)
                render.setVertexBuffer(vertexBuffer, offset: 0, atIndex: 0)
                render.drawPrimitives(.Triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
                render.endEncoding()
                commandBuffer.presentDrawable(drawable)
                commandBuffer.commit()
            }
        }
    }
#endif
}
