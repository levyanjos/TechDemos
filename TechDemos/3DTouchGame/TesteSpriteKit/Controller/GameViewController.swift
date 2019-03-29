//
//  GameViewController.swift
//  TesteSpriteKit
//
//  Created by Mateus Sales on 25/02/19.
//  Copyright © 2019 Mateus Sales. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation


class GameViewController: UIViewController {
    
    var musicPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                playMusic()
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func playMusic(){
        // Construindo uma URL a partir de um arquivo importado para o projeto
        if let musicURL = Bundle.main.url(forResource: "music", withExtension: "m4a"){
            musicPlayer = try! AVAudioPlayer(contentsOf: musicURL) // Para construir um objeto AVAudioPlayer você passa uma URL como paramêtro
            musicPlayer.numberOfLoops = -1 // Atribuindo -1 ao número de loops a música tocará indefinidademente
            musicPlayer.volume = 0.4 //Atribuindo o volume para o áudio
            musicPlayer.play() // Tocar a música
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
