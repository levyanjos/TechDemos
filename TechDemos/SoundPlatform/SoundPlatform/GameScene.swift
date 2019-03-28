//
//  GameScene.swift
//  SoundPlatform
//
//  Created by Alcides Junior on 26/03/19.
//  Copyright © 2019 Alcides Junior. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var snareSound = SKAction.playSoundFileNamed("snare.mp3", waitForCompletion: false)
    var kickSound = SKAction.playSoundFileNamed("kik.mp3", waitForCompletion: false)
    var hihatSound = SKAction.playSoundFileNamed("hihat.mp3", waitForCompletion: false)
    var objTouched: UITouch?
    var kickButton: SKShapeNode!
    var snareButton: SKShapeNode!
    var hihatButton: SKShapeNode!
    var playButton: SKShapeNode!
    var clearButton: SKShapeNode!
    var display: SKShapeNode!
    
    var selected = ""
    var played = false
    override func didMove(to view: SKView) {
        backgroundColor = #colorLiteral(red: 0.2176339626, green: 0.2455860078, blue: 0.3344992697, alpha: 1)
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = border

        physicsWorld.contactDelegate = self
        //velocidade do mundo
        physicsWorld.speed = 1.5
        
        let floor = Component(x: (self.view?.frame.width)!/2, y: 40, rotation: 0, width: view.frame.width, height: 1, name: "floor", image: "")
//        floor.
        addChild(floor.create())
        
        self.kickButton = SKShapeNode(rect: CGRect(x: Root.Position.x, y: Root.Position.y, width: Root.Size.width, height: Root.Size.height))
        self.kickButton.fillColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        self.kickButton.name = "kickButton"
        
        self.snareButton = SKShapeNode(rect: CGRect(x: Root.Position.x+100, y: Root.Position.y
            , width: Root.Size.width, height: Root.Size.height))
        self.snareButton.fillColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        self.snareButton.name = "snareButton"
        
        self.hihatButton = SKShapeNode(rect: CGRect(x: Root.Position.x+200, y: Root.Position.y, width: Root.Size.width, height: Root.Size.height))
        self.hihatButton.fillColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        self.hihatButton.name = "hihatButton"
        
        self.playButton = SKShapeNode(rect: CGRect(x: Root.Position.x+400, y: Root.Position.y, width: Root.Size.width, height: Root.Size.height))
        self.playButton.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.playButton.name = "playButton"
        
        self.clearButton = SKShapeNode(rect: CGRect(x: Root.Position.x + 500, y: Root.Position.y, width: Root.Size.width, height: Root.Size.height))
        self.clearButton.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.clearButton.name = "clearButton"
        
        addChild(self.kickButton)
        addChild(self.snareButton)
        addChild(self.hihatButton)
        addChild(self.playButton)
        addChild(self.clearButton)
        
    }
    
    func addPattern(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, rotation: CGFloat, name: String, image: String){
        let pattern = Component(x: x, y: y, rotation: rotation, width: width, height: height, name: name, image: image)
        addChild(pattern.create())
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self)
        let node = nodes(at: location!)
        
        if(selected != "" && node.first?.name == nil && self.played == false){
            self.addPattern(x: location!.x, y: location!.y, width: 70, height: 30, rotation: 0, name: self.selected, image: self.selected)
        }
        if node.first?.name == nil && self.played == true{
            let ball = Ball(ballName: "ball", x: location!.x, y: location!.y, zrotation: 0)
            addChild(ball.create())
        }
        
        if node.first?.name == "kickButton"{
            print("kick")
            self.selected = "kick"
            self.kickButton.lineWidth = 8
            self.snareButton.lineWidth = 0
            self.hihatButton.lineWidth = 0
        }else if node.first?.name == "snareButton"{
            print("snare")
            self.selected = "snare"
            self.kickButton.lineWidth = 0
            self.snareButton.lineWidth = 8
            self.hihatButton.lineWidth = 0
        }else if node.first?.name == "hihatButton"{
            print("hihat")
            self.selected = "hihat"
            self.kickButton.lineWidth = 0
            self.snareButton.lineWidth = 0
            self.hihatButton.lineWidth = 8
        }else if node.first?.name == "playButton"{
//            self.option =
            self.played = !self.played
            if self.played {
                self.playButton.fillColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                
            }else{
                self.playButton.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            
        }else if node.first?.name == "clearButton"{
            self.children.filter({$0.name == "kick"}).forEach({$0.removeFromParent()})
            self.children.filter({$0.name == "snare"}).forEach({$0.removeFromParent()})
            self.children.filter({$0.name == "hihat"}).forEach({$0.removeFromParent()})
            self.children.filter({$0.name == "ball"}).forEach({$0.removeFromParent()})
        }
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
}

extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == "ball" && contact.bodyB.node?.name == "hihat") || (contact.bodyA.node?.name == "hihat" && contact.bodyB.node?.name == "ball"){
            run(self.hihatSound)
            print("hihat")
        }
        if (contact.bodyA.node?.name == "ball" && contact.bodyB.node?.name == "snare") || (contact.bodyA.node?.name == "snare" && contact.bodyB.node?.name == "ball"){
            run(self.snareSound)
            print("snare")
        }
        if (contact.bodyA.node?.name == "ball" && contact.bodyB.node?.name == "kick") || (contact.bodyA.node?.name == "kick" && contact.bodyB.node?.name == "ball"){
            run(self.kickSound)
            print("kick")
        }
        if (contact.bodyA.node?.name == "ball" && contact.bodyB.node?.name == "floor") || (contact.bodyA.node?.name == "floor" && contact.bodyB.node?.name == "ball"){
            let children = [contact.bodyA.node!, contact.bodyB.node!].filter({$0.name == "ball"})
            removeChildren(in: children)
            
        }
    }
}
