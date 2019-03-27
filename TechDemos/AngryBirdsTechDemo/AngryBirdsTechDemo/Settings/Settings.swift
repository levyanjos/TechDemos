//
//  Settings.swift
//  AngryBirdsTechDemo
//
//  Created by Levy Cristian  on 25/02/19.
//  Copyright © 2019 Levy Cristian . All rights reserved.
//

import UIKit

/*
 -> projectileRadius : The radius of our projectile.
 -> projectileRestPosition : The initial position of the projectile on the scene.
 -> projectileTouchThreshold : The threshold outside the projectile radius in which the dragging process will start.
 -> projectileSnapLimit : If the user lifts the finger and the projectile is within this radius, it will snap back to initial position.
 -> forceMultiplier : The force multiplier for the original vector that slingshot is using to fire the projectile.
 -> rLimit : The radius of the virtual circle surrounding the slingshot.
 -> gravity: The gravity of the physics emulation. -9.8 is the default value but you can play with it to get the desire results.

 */

struct Settings {
    struct Metrics {
        static let projectileRadius = CGFloat(10)
        static let projectileRestPosition = CGPoint(x: 100, y: 70)
        static let projectileTouchThreshold = CGFloat(10)
        static let projectileSnapLimit = CGFloat(10)
        static let forceMultiplier = CGFloat(0.3)
        static let rLimit = CGFloat(50)
        
    }
    struct Game {
        static let gravity = CGVector(dx: 0,dy: -9.8)
        static let cameraOrign = CGPoint(x:UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
    }
}
