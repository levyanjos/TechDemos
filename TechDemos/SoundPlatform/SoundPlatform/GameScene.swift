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
    //adicionando os sons
    var snareSound = SKAction.playSoundFileNamed("snare.mp3", waitForCompletion: false)
    var kickSound = SKAction.playSoundFileNamed("kik.mp3", waitForCompletion: false)
    var hihatSound = SKAction.playSoundFileNamed("hihat.mp3", waitForCompletion: false)
    
    var objTouched: UITouch?
    //criando os elementos da tela
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
        //
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = border

        physicsWorld.contactDelegate = self
        //velocidade do mundo
        physicsWorld.speed = 1.5
        //criando e adicionando o chão
        let floor = Component(x: (self.view?.frame.width)!/2, y: 40, rotation: 0, width: view.frame.width, height: 1, name: "floor", image: "")
//        floor.
        addChild(floor.create())
        //definindo propriedades do kick
        self.kickButton = SKShapeNode(rect: CGRect(x: Root.Position.x, y: Root.Position.y, width: Root.Size.width, height: Root.Size.height))
        self.kickButton.fillColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        self.kickButton.name = "kickButton"
        //definindo propriedades da snare
        self.snareButton = SKShapeNode(rect: CGRect(x: Root.Position.x+100, y: Root.Position.y
            , width: Root.Size.width, height: Root.Size.height))
        self.snareButton.fillColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        self.snareButton.name = "snareButton"
        //definindo propriedades do hihat
        self.hihatButton = SKShapeNode(rect: CGRect(x: Root.Position.x+200, y: Root.Position.y, width: Root.Size.width, height: Root.Size.height))
        self.hihatButton.fillColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        self.hihatButton.name = "hihatButton"
        //definindo propriedades do play button
        self.playButton = SKShapeNode(rect: CGRect(x: Root.Position.x+400, y: Root.Position.y, width: Root.Size.width, height: Root.Size.height))
        self.playButton.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.playButton.name = "playButton"
        //definindo propriedades do clearButton
        self.clearButton = SKShapeNode(rect: CGRect(x: Root.Position.x + 500, y: Root.Position.y, width: Root.Size.width, height: Root.Size.height))
        self.clearButton.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.clearButton.name = "clearButton"
        //adicionando os elementos na cena
        addChild(self.kickButton)
        addChild(self.snareButton)
        addChild(self.hihatButton)
        addChild(self.playButton)
        addChild(self.clearButton)
        
    }
    //função responsável por adicionar os padrões de sons ao ter o contato bola~bloquinho
    func addPattern(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, rotation: CGFloat, name: String, image: String){
        let pattern = Component(x: x, y: y, rotation: rotation, width: width, height: height, name: name, image: image)
        addChild(pattern.create())
    }
    
    //capturando os toques na tela
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self)
        let node = nodes(at: location!)
        //adicionando os bloquinhos na tela apenas se o botão play não tiver sido tocado
        if(selected != "" && node.first?.name == nil && self.played == false){
            self.addPattern(x: location!.x, y: location!.y, width: 70, height: 30, rotation: 0, name: self.selected, image: self.selected)
        }
        //caso o botão de play tenha sido tocado, é possível adicionar uma bolinha na tela
        if node.first?.name == nil && self.played == true{
            let ball = Ball(ballName: "ball", x: location!.x, y: location!.y, zrotation: 0)
            addChild(ball.create())
        }
        //verificando se o botão kickButton foi tocado
        if node.first?.name == "kickButton"{
            print("kick")
            self.selected = "kick"
            self.kickButton.lineWidth = 8
            self.snareButton.lineWidth = 0
            self.hihatButton.lineWidth = 0
        //verificando se o botão kickButton foi tocado
        }else if node.first?.name == "snareButton"{
            print("snare")
            self.selected = "snare"
            self.kickButton.lineWidth = 0
            self.snareButton.lineWidth = 8
            self.hihatButton.lineWidth = 0
        //verificando se o botão hihatButton foi tocado
        }else if node.first?.name == "hihatButton"{
            print("hihat")
            self.selected = "hihat"
            self.kickButton.lineWidth = 0
            self.snareButton.lineWidth = 0
            self.hihatButton.lineWidth = 8
        //verificando se o botão playButton foi tocado
        }else if node.first?.name == "playButton"{
            //dizemos que o botão play foi tocado e alteramos o valor da variavel
            self.played = !self.played
            if self.played {
                self.playButton.fillColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                
            }else{
                self.playButton.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        //quando o botao clear é clicado, removemos todos os elementos que foram adicionados pelo usuário
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
        //checando se houve contato da bolinha com o hihat
        if (contact.bodyA.node?.name == "ball" && contact.bodyB.node?.name == "hihat") || (contact.bodyA.node?.name == "hihat" && contact.bodyB.node?.name == "ball"){
            //disparando o som de hihat
            run(self.hihatSound)
            print("hihat")
        }
        //checando se houve contato da bolinha com a snare
        if (contact.bodyA.node?.name == "ball" && contact.bodyB.node?.name == "snare") || (contact.bodyA.node?.name == "snare" && contact.bodyB.node?.name == "ball"){
            run(self.snareSound)
            print("snare")
        }
        //checando se houve contato da bolinha com o kick
        if (contact.bodyA.node?.name == "ball" && contact.bodyB.node?.name == "kick") || (contact.bodyA.node?.name == "kick" && contact.bodyB.node?.name == "ball"){
            //disparando o som de kick
            run(self.kickSound)
            print("kick")
        }
        //checando se houve contato da bolinha com o floor
        if (contact.bodyA.node?.name == "ball" && contact.bodyB.node?.name == "floor") || (contact.bodyA.node?.name == "floor" && contact.bodyB.node?.name == "ball"){
            let children = [contact.bodyA.node!, contact.bodyB.node!].filter({$0.name == "ball"})
            //removendo a bolinha
            removeChildren(in: children)
            
        }
    }
}
