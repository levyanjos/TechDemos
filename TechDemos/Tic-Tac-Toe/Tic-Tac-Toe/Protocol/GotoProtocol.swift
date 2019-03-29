//
//  GotoProtocol.swift
//  Tic-Tac-Toe
//
//  Created by Paloma Bispo on 25/02/19.
//  Copyright © 2019 Paloma Bispo. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

//Used to move to another scene or controller
protocol GoToProtocol {
    func goTo(viewController: UIViewController)//used to tell the controller to go to another  viewController
    func goTo(scene: SKScene) //used to tell the controller to go to a scene
}
