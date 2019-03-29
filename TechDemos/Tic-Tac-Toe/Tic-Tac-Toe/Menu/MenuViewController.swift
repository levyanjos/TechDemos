//
//  MenuViewController.swift
//  Tic-Tac-Toe
//
//  Created by Paloma Bispo on 24/02/19.
//  Copyright © 2019 Paloma Bispo. All rights reserved.
//

import UIKit
import SpriteKit

class MenuViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        if let skview = self.view as? SKView {
            let menuScene = MenuScene.init(size: UIScreen.main.bounds.size)
            menuScene.goToProtocol = self
            menuScene.scaleMode = .resizeFill
            menuScene.backgroundColor = SKColor().background()
            skview.presentScene(menuScene)
        }

    }
}

extension MenuViewController: GoToProtocol {
    func goTo(viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func goTo(scene: SKScene) {
        if let skview = self.view as? SKView {
            scene.scaleMode = .resizeFill
            skview.presentScene(scene)
        }
    }
}
