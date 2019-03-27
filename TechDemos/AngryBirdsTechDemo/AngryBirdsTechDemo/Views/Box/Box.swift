//
//  Box.swift
//  AngryBirdsTechDemo
//
//  Created by Levy Cristian  on 25/02/19.
//  Copyright © 2019 Levy Cristian . All rights reserved.
//

import SpriteKit

class Box: SKSpriteNode {
    var integrity: Int = 2 {
        didSet {
            if integrity > 2 {
                integrity = 2
            }
            if integrity < 0 {
                removeFromParent()
            }
            texture = SKTexture(imageNamed: "box_\(integrity)")
        }
    }
}
