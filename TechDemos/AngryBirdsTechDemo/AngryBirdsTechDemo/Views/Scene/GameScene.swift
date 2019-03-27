//
//  GameScene.swift
//  AngryBirdsTechDemo
//
//  Created by Levy Cristian  on 19/02/19.
//  Copyright © 2019 Levy Cristian . All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private lazy var background: SKSpriteNode = {
        let background = SKSpriteNode(imageNamed: "background_0")
        background.position = CGPoint(x: 0 , y: 0)
        background.anchorPoint = CGPoint(x: 0, y:0)
        background.zPosition = 0
        return background
    }()
    
    private lazy var border: SKPhysicsBody = {
        let border = SKPhysicsBody(edgeLoopFrom: background.frame)
        border.friction = 1
        return border
    }()

    private lazy var slingshot: SKSpriteNode = {
        let slingshot_1 = SKSpriteNode(imageNamed: "sling")
        slingshot_1.position = CGPoint(x: 100, y: 50)
        slingshot_1.zPosition = 2
        return slingshot_1
    }()
 
    private lazy var bird: Bird = {
        let projectilePath = UIBezierPath(
            arcCenter: CGPoint.zero,
            radius: Settings.Metrics.projectileRadius,
            startAngle: 0,
            endAngle: CGFloat(Double.pi * 2),
            clockwise: true
        )
        let bird = Bird(path: projectilePath, color: UIColor.orange, borderColor: UIColor.white)
        bird.position = Settings.Metrics.projectileRestPosition
        bird.zPosition = 1
        return bird
    }()
    
    private lazy var cameraNode: Camera = {
        let cameraNode = Camera(sceneView: self.view!, worldNode: background)
        cameraNode.position = Settings.Game.cameraOrign
        return cameraNode
    }()
    
    
    private var projectileIsDragged = false
    private var touchCurrentPoint: CGPoint!
    var touchStartingPoint: CGPoint!
    
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        anchorPoint = CGPoint(x: 0, y:0)
        self.size = background.size
        
        physicsBody = border
        physicsWorld.gravity = Settings.Game.gravity
        physicsWorld.speed = 0.5
        camera = cameraNode
        
        addChild(background)
        background.addChild(slingshot)
        background.addChild(bird)
        addChild(cameraNode)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //verify if bird can be dragged in a location
        func shouldStartDragging(touchLocation:CGPoint, threshold: CGFloat) -> Bool {
            // verify distance from finger to rest point
            let distance = fingerDistanceFromProjectileRestPosition(
                projectileRestPosition: Settings.Metrics.projectileRestPosition,
                fingerPosition: touchLocation
            )
            return distance < Settings.Metrics.projectileRadius + threshold
        }
        
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            
            // virify if a bird isn't dragged yet and user finger is near to rest bird point
            if !projectileIsDragged && shouldStartDragging(touchLocation: touchLocation, threshold: Settings.Metrics.projectileTouchThreshold)  {
                touchStartingPoint = touchLocation
                touchCurrentPoint = touchLocation
                projectileIsDragged = true
            }else{
                

            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if projectileIsDragged {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                
                //calculates the distance from finger in resto position radius
                let distance = fingerDistanceFromProjectileRestPosition(projectileRestPosition: touchLocation, fingerPosition: touchStartingPoint)
                
                //virify if user finger are inside the radius limite. In case of true finger point is iqual to bird point, in case of false we should calculates bird point relative to finger point in area screen.
                if distance < Settings.Metrics.rLimit  {
                    touchCurrentPoint = touchLocation
                } else {
                    touchCurrentPoint = projectilePositionForFingerPosition(
                        fingerPosition: touchLocation,
                        projectileRestPosition: touchStartingPoint,
                        rLimit: Settings.Metrics.rLimit
                    )
                }
            }
            bird.position = touchCurrentPoint
        }else{
            bird.physicsBody = nil
            bird.position = Settings.Metrics.projectileRestPosition
            
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let previousLocation = touch.previousLocation(in: self)
                let deltaX = touchLocation.x - previousLocation.x
                
                let range = cameraNode.position.x - deltaX
                if range > Settings.Game.cameraOrign.x && range < (self.frame.width/2 + 30) {
                    cameraNode.position.x = range
                }
        
            }
        }
      
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if projectileIsDragged {
            projectileIsDragged = false
            //let velocity =
            let distance = fingerDistanceFromProjectileRestPosition(projectileRestPosition: touchCurrentPoint, fingerPosition: touchStartingPoint)
            //verify if distance between finger point and brid is greater than cancel area. If is true, the impulse will occur else the bird return to rest point
            if distance > Settings.Metrics.projectileSnapLimit {
                //Δx
                let vectorX = touchStartingPoint.x - touchCurrentPoint.x
                //Δy
                let vectorY = touchStartingPoint.y - touchCurrentPoint.y
                bird.physicsBody = SKPhysicsBody(circleOfRadius: Settings.Metrics.projectileRadius)
                //Apply a oblique throw at the bird based in Δx, Δy and a multiplier
                bird.physicsBody?.applyImpulse(
                    CGVector(
                        dx: vectorX * Settings.Metrics.forceMultiplier,
                        dy: vectorY * Settings.Metrics.forceMultiplier
                    )
                )
                
            } else {
                bird.physicsBody = nil
                bird.position = Settings.Metrics.projectileRestPosition
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
   
    }


    override func update(_ currentTime: TimeInterval) {
    
        
        
    }
    
}

extension GameScene {
    
    //calculates the distance between finger and project rest point
    func fingerDistanceFromProjectileRestPosition(projectileRestPosition: CGPoint, fingerPosition: CGPoint) -> CGFloat {
        return sqrt(pow(projectileRestPosition.x - fingerPosition.x,2) + pow(projectileRestPosition.y - fingerPosition.y,2))
    }
    
    //calcules whats the project position shuold to be
    func projectilePositionForFingerPosition(fingerPosition: CGPoint, projectileRestPosition:CGPoint, rLimit:CGFloat) -> CGPoint {
        
        
        let θ = atan2(fingerPosition.x - projectileRestPosition.x, fingerPosition.y - projectileRestPosition.y)
        let cX = sin(θ) * rLimit
        let cY = cos(θ) * rLimit
        return CGPoint(x: cX + projectileRestPosition.x, y: cY + projectileRestPosition.y)
    }
    
}


extension GameScene{
    
    
}

