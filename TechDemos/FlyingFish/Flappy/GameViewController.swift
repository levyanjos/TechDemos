//
//  GameViewController.swift
//  Flappy
//
//  Created by Mateus Sales on 04/02/19.
//  Copyright © 2019 Mateus Sales. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation


class GameViewController: UIViewController {
    
    var stage: SKView!
    var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stage = view as? SKView
        stage.ignoresSiblingOrder = true // Evita flips de objetos que ficam na frente do outro
        
        presentScene()
        playMusic()
    }
    
    func playMusic() {
        if let musicURL = Bundle.main.url(forResource: "music", withExtension: "m4a") {
            musicPlayer = try! AVAudioPlayer(contentsOf: musicURL)
            musicPlayer.numberOfLoops = -1 // Rodar indefinidademente
            musicPlayer.volume = 0.4
            musicPlayer.play()
        }
    }
    
    func presentScene(){
        let scene = GameScene(size: CGSize(width: 320, height: 568))
        scene.scaleMode = .aspectFill
        scene.gameViewController = self
        //stage.presentScene(scene)
        stage.presentScene(scene, transition: .doorsOpenVertical(withDuration: 0.5))
    }


    override var prefersStatusBarHidden: Bool {
        return true
    }
}
