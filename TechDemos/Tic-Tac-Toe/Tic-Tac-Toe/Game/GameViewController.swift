//
//  GameViewController.swift
//  Tic-Tac-Toe
//
//  Created by Paloma Bispo on 19/02/19.
//  Copyright © 2019 Paloma Bispo. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = SKView(frame: view.frame)
        guard let skview = self.view as? SKView else { return }
        let sizeScene = UIScreen.main.bounds.size
        let gameScene = GameScene.init(size: sizeScene)
        gameScene.presentingProtocol = self
        gameScene.scaleMode = .resizeFill
        skview.presentScene(gameScene)
    }
}

extension GameViewController: PresentingProtocol {
    
    func dismissCurrent() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func present(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
