//
//  Pattern.swift
//  SoundPlatform
//
//  Created by Alcides Junior on 26/03/19.
//  Copyright © 2019 Alcides Junior. All rights reserved.
//

import SpriteKit
class Ball{
    private var x: CGFloat?
    private var y: CGFloat?
    private var zrotation: CGFloat?
    private var width: CGFloat?
    private var height: CGFloat?
    private var ballName: String?
    private var color: UIColor?
    
    init(ballName: String, x:CGFloat,  y: CGFloat,   zrotation:CGFloat = 0, _ width: CGFloat = 70,_ height: CGFloat = 20){
        self.ballName = ballName
        self.x = x
        self.y = y
        self.zrotation = zrotation
        self.width = width
        self.height = height
    }
    
    func create()->SKSpriteNode{
        
        let element = SKSpriteNode(texture: SKTexture(imageNamed: "ball"))

        element.position = CGPoint(x: self.x ?? 100 ,y: self.y ?? 100)
        element.size = CGSize(width: 10, height: 10)
//        element.fillColor = self.color!
        element.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        //setting configs to collision
        element.physicsBody?.restitution = 1
        element.physicsBody?.categoryBitMask = 2
        element.physicsBody?.collisionBitMask = 1
        element.physicsBody?.fieldBitMask = 0
        element.physicsBody?.contactTestBitMask = 1
        
        element.zRotation = self.zrotation!
        element.name = self.ballName!
        
        return element
    }
}
