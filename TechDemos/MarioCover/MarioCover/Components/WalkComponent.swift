//
//  WalkComponent.swift
//  MyGame
//
//  Created by Ramires Moreira on 01/03/19.
//  Copyright © 2019 Ramires Moreira. All rights reserved.
//

import GameplayKit


enum Orientation: CGFloat {
    case foward = 1
    case back = -1
}

class WalkComponent: GKComponent {
    
    let node : SKSpriteNode
    private var animationComponent: MovementComponent?
    
    private(set) var isMoving = false
    
    init(withNode node: SKSpriteNode, animation : MovementComponent? = nil ) {
        self.node = node
        self.animationComponent = animation
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(to orientation : Orientation, velocity : CGFloat){
        isMoving = true
        if orientation == .foward && node.xScale > 0 {
            node.xScale *= -1
        }else if orientation == .back && node.xScale < 0 {
            node.xScale *= -1
        }
        let vector = CGVector(dx: velocity * orientation.rawValue , dy: node.physicsBody?.velocity.dy ?? 0)
        node.physicsBody?.velocity = vector
        animationComponent?.animateWalk(node: node)
    }
    
    func stop() {
         isMoving = false
        node.physicsBody?.velocity = .zero
        animationComponent?.stopAnimate(node: node)
    }
}
