//
//  GameViewController.swift
//  MyGame
//
//  Created by Ramires Moreira on 19/02/19.
//  Copyright © 2019 Ramires Moreira. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameController

class GameViewController: UIViewController {
    
    var controller: GCController!
    var scene: GameScene!
    
    var gameRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = view as! SKView
        skView.ignoresSiblingOrder = true
        scene = GameScene(fileNamed: "Background")
        scene.scaleMode = .aspectFill
        scene.size = view.bounds.size
        skView.presentScene(scene)
        let center = NotificationCenter.default
        let notification: NSNotification.Name = Notification.Name.GCControllerDidConnect
        let selector = #selector(didConnection)
        center.addObserver(self, selector: selector, name: notification, object: nil)
        
        let disconnect = NSNotification.Name.GCControllerDidDisconnect
        let selector2 = #selector(addButtons)
        center.addObserver(self, selector: selector2, name: disconnect, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(toogleDebug))
        tap.numberOfTapsRequired = 2
        scene.view?.addGestureRecognizer(tap)
        skView.preferredFramesPerSecond = 30
    }
    
    @objc func toogleDebug(){
        let skView = view as! SKView
        skView.showsPhysics = !skView.showsPhysics
        skView.showsFPS = !skView.showsFPS
        skView.showsNodeCount = !skView.showsNodeCount
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func didConnection(){
        guard let controller = GCController.controllers().first else {
            return
        }
        scene.removeButtons()
        let rightButton = controller.extendedGamepad?.dpad.right
        rightButton?.pressedChangedHandler = buttonFowardHandler(button:num:test:)
        controller.extendedGamepad?.dpad.left.pressedChangedHandler = buttonbackHandler(button:num:test:)
        controller.extendedGamepad?.buttonA.pressedChangedHandler = buttonAHandler(button:num:test:)
        controller.extendedGamepad?.leftThumbstick.left.pressedChangedHandler = buttonbackHandler(button:num:test:)
        controller.extendedGamepad?.leftThumbstick.right.pressedChangedHandler = buttonFowardHandler(button:num:test:)
        controller.controllerPausedHandler = { pad in
            self.scene.isPaused = !self.scene.isPaused
            if self.scene.isPaused {
                self.scene.musicPlayer.pause()
            }else{
                self.scene.musicPlayer.play()
            }
        }
        
    }
    
    func buttonFowardHandler(button: GCControllerButtonInput, num: Float, test:  Bool) -> Void {
        if !button.isPressed {
            scene.mario.stop()
            return
        }
        scene.mario.foward()
    }
    
    func buttonbackHandler(button: GCControllerButtonInput, num: Float, test:  Bool) -> Void {
        if !button.isPressed {
            scene.mario.stop()
            return
        }
        scene.mario.back()
    }
    
    func buttonAHandler(button: GCControllerButtonInput, num: Float, test:  Bool) -> Void {
        if button.isPressed {
            scene.mario.jump()
        }
    }
    
    @objc func addButtons(){
        scene.addButtonToScreen()
    }
}
