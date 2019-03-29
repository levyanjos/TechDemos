//
//  Luigi.swift
//  MyGame
//
//  Created by Ramires Moreira on 01/03/19.
//  Copyright © 2019 Ramires Moreira. All rights reserved.
//

import GameplayKit

class Mario: GKEntity, MarioMovement {
    
    private(set) var node: SKSpriteNode
    private let sheet: SpriteSheet
    override init() {
        sheet = SpriteSheet(imageNamed: "mario_set", rows: 11, columns: 6) { position -> Bool in
            return position.column > 1 && position.row == 10
        }
        let idleTexture = sheet.textureFor(row: 0, column: 0)
        self.node = SKSpriteNode(texture: idleTexture)
        self.node.setScale(0.2)
        self.node.zPosition = 10
        super.init()
        addComponents()
        configurePhysicsBody()
    }
    
    func addComponents() {
        let jumpComponent = JumpComponent(withNode: self.node)
        jumpComponent.soundFileName = "jump"
        addComponent(jumpComponent)
        
        let animationComponent = MovementComponent(walk: sheet.allTxtures(), idle: [node.texture!])
        let walkComponent = WalkComponent(withNode: self.node, animation: animationComponent)
        addComponent(walkComponent)
    }
    
    func configurePhysicsBody() {
        let size = CGSize(width: node.size.width/2, height: node.size.height - 5.0)
        self.node.physicsBody = SKPhysicsBody(rectangleOf: size )
        self.node.physicsBody?.allowsRotation = false
        self.node.physicsBody?.restitution = 0
        self.node.physicsBody?.friction = 0
        self.node.physicsBody?.linearDamping = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
