//
//  MarioMovement.swift
//  MyGame
//
//  Created by Ramires Moreira on 13/03/19.
//  Copyright © 2019 Ramires Moreira. All rights reserved.
//

import CoreGraphics
import GameKit

protocol MarioMovement {
    
}

extension MarioMovement where Self : Mario {
    
    var walkVelocity : CGFloat {
        get {
            return 100.0
        }
    }
    
    func jump()  {
        component(ofType: JumpComponent.self)?.jump(y: 20)        
    }
    
    func foward() {
        component(ofType: WalkComponent.self)?.move(to: .foward, velocity: walkVelocity)
    }
    
    func back() {
        component(ofType: WalkComponent.self)?.move(to: .back, velocity: walkVelocity)
    }
    
    func stop() {
        component(ofType: WalkComponent.self)?.stop()
    }
}
