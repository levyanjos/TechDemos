//
//  Component.swift
//  SoundPlatform
//
//  Created by Alcides Junior on 26/03/19.
//  Copyright © 2019 Alcides Junior. All rights reserved.
//

import SpriteKit

class Component{
    private var x: CGFloat!
    private var y: CGFloat!
    private var rotation: CGFloat!
    private var width: CGFloat!
    private var height: CGFloat!
    private var name: String!
    private var image: String!
    
    
    init(x: CGFloat, y: CGFloat, rotation: CGFloat, width: CGFloat, height: CGFloat, name: String, image: String){
        self.x = x
        self.y = y
        self.rotation = rotation
        self.width = width
        self.height = height
        self.name = name
        self.image = image
    }
    func create()->SKSpriteNode{
        let element = SKSpriteNode(imageNamed: self.image)
    
        element.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        element.position = CGPoint(x: self.x, y: self.y)
        element.size = CGSize(width: self.width, height: self.height)
        element.zRotation = self.rotation
        element.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.width, height: self.height) )
        element.physicsBody?.categoryBitMask = 1
        element.physicsBody?.collisionBitMask = 2
        element.physicsBody?.fieldBitMask = 0
        element.physicsBody?.contactTestBitMask = 2
        element.physicsBody?.isDynamic = false
        element.name = name
        return element
    }
}
