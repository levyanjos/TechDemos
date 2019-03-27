//
//  Camera.swift
//  AngryBirdsTechDemo
//
//  Created by Levy Cristian  on 28/02/19.
//  Copyright © 2019 Levy Cristian . All rights reserved.
//

import SpriteKit
import UIKit

class Camera : SKCameraNode {
    
    // MARK: Properties
    
    /** The node the camera intereacts with. Anything you want to be effected by the camera should be a child of this node. */
    let worldNode: SKNode
    
    /** Bounds the camera constrains the worldNode to. Default value is the size of the view but this can be changed. */
    private var bounds: CGRect
    
    /** The current zoom scale of the camera. */
    private var zoomScale: CGFloat
    
    /** Min/Max scale the camera can zoom in/out. */
    var zoomRange: (min: CGFloat, max: CGFloat)
    
    /** Enable/Disable the ability to zoom the camera. */
    var allowZoom: Bool
    
    private var isEnabled: Bool
    
    /** Enable/Disable the camera. */
    var enabled: Bool {
        get { return isEnabled }
        set {
            isEnabled = newValue
            
            
            longPressGestureRecognizer.isEnabled = newValue
            pinchGestureRecognizer.isEnabled = newValue
            
        }
    }
    
    /** Enable/Disable clamping of the worldNode */
    var enableClamping: Bool
    
    /** Delegates are informed when the camera repositions or performs some other action. */
    private var delegates: [SKTilemapCameraDelegate] = []
    
    /** Previous touch/mouse location the last time the position was updated. */
    private var previousLocation: CGPoint!
    
    // MARK: Initialization
    
    /** Initialize a basic camera. */
    init(sceneView: SKView, worldNode: SKNode) {
        
        self.worldNode = worldNode
        bounds = sceneView.bounds
        zoomScale = 1.0
        zoomRange = (1, 1.3)
        allowZoom = true
        isEnabled = true
        enableClamping = true
        
        super.init()
        
        
        pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.updateScale(_:)))
        sceneView.addGestureRecognizer(pinchGestureRecognizer)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Input - iOS
    
    /** Used for zooming/scaling the camera. */
    var pinchGestureRecognizer: UIPinchGestureRecognizer!
    var longPressGestureRecognizer: UILongPressGestureRecognizer!
    
    /** Used to determine the intial touch location when the user performs a pinch gesture. */
    private var initialTouchLocation = CGPoint.zero
    
    // MARK: Input
    /** Scales the worldNode using input from a pinch gesture recogniser.
     Any delegates of the camera will be informed that the camera changed scale. */
    @objc func updateScale(_ recognizer: UIPinchGestureRecognizer) {
        
        guard let scene = self.scene else { return }
        
        if recognizer.state == .began {
            initialTouchLocation = scene.convertPoint(fromView: recognizer.location(in: recognizer.view))
           
            
           
        }
        
        if recognizer.state == .changed && enabled && allowZoom {
            
            zoomScale *= recognizer.scale
            applyZoomScale(scale: zoomScale)
            recognizer.scale = 1
            centerOnPosition(scenePosition: CGPoint(x: initialTouchLocation.x * zoomScale, y: initialTouchLocation.y * zoomScale))
            
        }
        
        if recognizer.state == .ended { }
    }
    
    
    
    // MARK: Positioning
    
    /** Moves the camera so it centers on a certain position within the scene. Easing can be applied by setting a timing
     interval. Otherwise the position is changed instantly. */
    func centerOnPosition(scenePosition: CGPoint, easingDuration: TimeInterval = 0) {
        
        if easingDuration == 0 {
            
            position = scenePosition
            clampWorldNode()
            for delegate in delegates { delegate.didUpdatePosition(position: position, scale: zoomScale, bounds: self.bounds) }
            
        } else {
            
            let moveAction = SKAction.move(to: scenePosition, duration: easingDuration)
            moveAction.timingMode = .easeOut
            
            let blockAction = SKAction.run({
                self.clampWorldNode()
                for delegate in self.delegates { delegate.didUpdatePosition(position: self.position, scale: self.zoomScale, bounds: self.bounds) }
            })
            
            run(SKAction.group([moveAction, blockAction]))
        }
    }
    
    
    // MARK: Scaling and Zoom
    
    /** Applies a scale to the worldNode. Ensures that the scale stays within its range and that the worldNode is
     clamped within its bounds. */
    func applyZoomScale(scale: CGFloat) {
        
        var zoomScale = scale
        
        if zoomScale < zoomRange.min {
            zoomScale = zoomRange.min
        } else if zoomScale > zoomRange.max {
            zoomScale = zoomRange.max
        }
        
        self.zoomScale = zoomScale
        worldNode.setScale(zoomScale)
        
        for delegate in delegates { delegate.didUpdateZoomScale(position: position, scale: zoomScale, bounds: self.bounds) }
    }
    
    /** Returns the minimum zoom scale possible for the size of the worldNode. Useful when you don't want the worldNode
     to be displayed smaller than the current bounds. */
    func minimumZoomScale() -> CGFloat {
        
        let frame = worldNode.calculateAccumulatedFrame()
        
        if bounds == CGRect.zero || frame == CGRect.zero { return 0 }
        
        let xScale = (bounds.width * zoomScale) / frame.width
        let yScale = (bounds.height * zoomScale) / frame.height
        return min(xScale, yScale)
    }
    
    // MARK: Bounds
    
    /** Keeps the worldNode clamped between a specific bounds. If the worldNode is smaller than these bounds it will
     stop it from moving outside of those bounds. */
    private func clampWorldNode() {
        
        if !enableClamping { return }
        
        let frame = UIScreen.main.bounds
        var minX = bounds.size.width/2
        var maxX = bounds.size.width/2
        var minY = bounds.size.height/2
        var maxY = bounds.size.height/2
        
        if frame.width < bounds.width {
            swap(&minX, &maxX)
        }

        if frame.height < bounds.height {
            swap(&minY, &maxY)
        }
        
        if position.x < minX {
            position.x = CGFloat(Int(minX))
        } else if position.x > maxX {
            position.x = CGFloat(Int(maxX))
        }
        
        if position.y < minY {
            position.y = CGFloat(Int(minY))
        } else if position.y > maxY {
            position.y = CGFloat(Int(maxY))
        }
    }
    
    /** Returns the current bounds the camera is using. */
    func getBounds() -> CGRect {
        return bounds
    }
    
    /** Updates the bounds for the worldNode to be constrained to. Will inform all delegates this change occured. */
    func updateBounds(bounds: CGRect) {
        
        self.bounds = bounds
        for delegate in delegates { delegate.didUpdateBounds(position: position, scale: zoomScale, bounds: self.bounds) }
    }
}
