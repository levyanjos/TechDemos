//
//  JumpComponent.swift
//  MyGame
//
//  Created by Ramires Moreira on 01/03/19.
//  Copyright © 2019 Ramires Moreira. All rights reserved.
//

import GameKit

class JumpComponent: GKComponent {
    
    let node : SKSpriteNode
    private var animationComponent: MovementComponent?
    var soundFileName : String?
    
    init(withNode node: SKSpriteNode, animation : MovementComponent? = nil) {
        self.node = node
        self.animationComponent = animation
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func jump(_ vector: CGVector) {
        if node.physicsBody?.velocity.dy == 0 {
            node.physicsBody?.applyImpulse(vector)
        }
        if let file = soundFileName {
            let sound = SKAction.playSoundFileNamed(file, waitForCompletion: false)
            node.run(sound)
        }
    }
    
    func jump(y : CGFloat) {
        let vector = CGVector(dx: 0, dy: y)
        jump(vector)
    }

}
