//
//  Bird.swift
//  AngryBirdsTechDemo
//
//  Created by Levy Cristian  on 25/02/19.
//  Copyright © 2019 Levy Cristian . All rights reserved.
//

import SpriteKit


class Bird: SKShapeNode {
    convenience init(path: UIBezierPath, color: UIColor, borderColor:UIColor) {
        self.init()
        self.path = path.cgPath
        self.fillColor = color
        self.strokeColor = borderColor
    }
}
