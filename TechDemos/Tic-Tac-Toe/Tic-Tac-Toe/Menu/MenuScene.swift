//
//  MenuGame.swift
//  Tic-Tac-Toe
//
//  Created by Paloma Bispo on 22/02/19.
//  Copyright © 2019 Paloma Bispo. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScene: SKScene {

    var playButton = SKSpriteNode()
    var settingsButton = SKSpriteNode()
    
    //textures of play and settings buttons
    private let playButtonTex = SKTexture(imageNamed: "play")
    private let settingsButtonTex = SKTexture(imageNamed: "settings")
    
    // protocols
    var goToProtocol: GoToProtocol!
    var presentingProtocol: PresentingProtocol!
    
    
    
    override func didMove(to view: SKView) {
        initialSetup()
        addChilds()
        positionSetup()
    }
    
    private func addChilds(){
        addChild(playButton)
        addChild(settingsButton)
    }
    
    private func positionSetup(){
        let height = playButton.frame.height
        playButton.position = CGPoint(x: frame.midX, y: frame.midY + height/2)
        settingsButton.position = CGPoint(x: frame.midX, y: playButton.frame.minY-height)
    }
    
    private func initialSetup(){
        //setting the anchor point of the scene
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        //applying textures
        playButton = SKSpriteNode(texture: playButtonTex)
        settingsButton = SKSpriteNode(texture: settingsButtonTex)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //gets the node of the touche's position and check
        if let playTouch = touches.first {
            let position = playTouch.location(in: self)
            guard let node = self.nodes(at: position).first else {return}
            // if the node is playButton go to GameViewController
            if node == playButton {
                goToProtocol.goTo(viewController: GameViewController())
            // if the node is settingsButton go to SettingsViewController
            }else if node == settingsButton {
                goToProtocol.goTo(viewController: SettingsViewController())
            }
        }
    }
}
