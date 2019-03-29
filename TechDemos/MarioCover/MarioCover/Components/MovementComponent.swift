//
//  AnimateComponent.swift
//  MyGame
//
//  Created by Ramires Moreira on 12/03/19.
//  Copyright © 2019 Ramires Moreira. All rights reserved.
//

import GameKit

class MovementComponent: GKComponent {
    
    enum KeyAction: String {
        case iddle = "iddle"
        case walk = "walk"
    }
    
    let walk : [SKTexture]?
    let idle : [SKTexture]?
    
    init( walk : [SKTexture]?, idle: [SKTexture]? ){
        self.walk = walk
        self.idle = idle
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func stopAnimate(node : SKSpriteNode){
        node.removeAllActions()
        guard let iddle = idle else {return}
        animate(node: node, walkFrames: iddle, with: .iddle)
    }
    
    func animateWalk(node : SKSpriteNode) {
        node.removeAction(forKey: KeyAction.iddle.rawValue)
        guard let walk = walk else {return}
        animate(node: node, walkFrames: walk, with: .walk)
    }
    
    private func animate( node : SKSpriteNode,  walkFrames : [SKTexture], with key: KeyAction, repeatForever : Bool = true) {

        if node.action(forKey: key.rawValue) == nil {
            let interval = TimeInterval(exactly:  1.0/CGFloat(walkFrames.count))!
            
            let action = SKAction.animate(with: walkFrames, timePerFrame: interval , resize: false, restore: true)
            if repeatForever {
                let repeatAction = SKAction.repeatForever(action)
                node.run(repeatAction, withKey: key.rawValue)
            }else{
                node.run(action, withKey: key.rawValue)
            }
        }
    }
    
}
