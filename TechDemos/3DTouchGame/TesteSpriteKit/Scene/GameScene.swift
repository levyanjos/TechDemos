//
//  GameScene.swift
//  TesteSpriteKit
//
//  Created by Mateus Sales on 25/02/19.
//  Copyright © 2019 Mateus Sales. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // O player em si correspondem a dois retângulos de cor amarela que se abrem na mesma proporção em sentidos opostos
    var player: SKSpriteNode! // Nó para representar o player 1
    var player2: SKSpriteNode! // Nó para representar o player 2
    var score: Int = 0 // Pontuação do jogador
    var lifes: Int = 3 // Quantidade de vidas
    var label: SKLabelNode! // String: "Score: 0", por exemplo
    var laser = SKNode() // Laser que vai contabilizar os obstáculos superados pelo jogador
    var record: Int = UserDefaults.standard.integer(forKey: "Record") // Variável que vai guardar o record naquele dispositivo
    
    // Posição inicial, esta posição é fundamental, pois sempre que o usuário parar de tocar na tela o player volta para a posição inicial
    var initialPlayerPosition: CGPoint!
    
    // Sons que vão tocar no jogo
    let scoreSound = SKAction.playSoundFileNamed("score.mp3", waitForCompletion: false)
    let gameOverSound = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)
    
    // Elementos da tela que representam a quantidade de vidas
    var lifeOne: SKSpriteNode!
    var lifeTwo: SKSpriteNode!
    var lifeThree: SKSpriteNode!
    
    // Delegate para enviar pontuação atual e record para a tela de game over
    var scoreDelegate: ScoreDelegate?
    var recordDelegate: RecordDelegate?
    var recordString: String = "" // String a ser exibida caso tenha ocorrido um novo record
    
    // Utilizada para gerar vibrações
    let notification = UINotificationFeedbackGenerator()
    
    // Gestures uitilizados para pausar e para continuar o jogo
    let swipeUp = UISwipeGestureRecognizer() // Pause no game
    let swipeDown = UISwipeGestureRecognizer() // Play no game
    
    // Tela de game over que é chamada quando o usuário perder as três vidas
    private lazy var  gameOverScene : GameOverScene = {
       return GameOverScene(size: self.size)
    }()
    
    // Este método é chamado quando a nova cena é criada
    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0) // Definindo um mundo sem gravidade
        self.physicsWorld.contactDelegate = self // Informando que nossa classe GameScne implementará o protocolo para identificar os contatos
        
        // Implementação do delegate
        self.scoreDelegate = gameOverScene
        self.recordDelegate = gameOverScene
        
        // Funções
        addPlayer() // Adicionando player
        addScore() // Adicionando label de score
        addLaser() // Adicionando laser para contabilizar pontuação do jogador
        addLifes() // Adicionando as vidas do jogador
        addGesture() // Adicionando gestures para pause e play do jogo
    }
    
    func addGesture(){
        // Swipe para cima que será uitlizado para pausar o jogo
        swipeUp.addTarget(self, action: #selector(swipedUp))
        swipeUp.direction = .up
        self.view?.addGestureRecognizer(swipeUp)
        
        // Swipe para baixo que será uitlizado para dar play no jogo
        swipeDown.addTarget(self, action: #selector(swipedDown))
        swipeDown.direction = .down
        self.view?.addGestureRecognizer(swipeDown)
    }
    
    // Swipe para cima utilizado para pausar o jogo
    @objc func swipedUp(){
        print("Swipe para cima")
        self.isPaused = true
        self.player.isPaused = true
        self.player2.isPaused = true
    }
    
    // Swipe para baixo utilizado para dar play no jogo
    @objc func swipedDown(){
        print("Swipe para baixo")
        self.isPaused = false
        self.player.isPaused = false
        self.player.isPaused = false
    }
    
    // Esta função vai adicionar um tipo de linha de forma aleatória na tela do usuário
    
    func addRandomRow() {
        let randomNumber = Int(arc4random_uniform(6))
        
        switch randomNumber {
        case 0:
            addRow(type: RowType(rawValue: 0)!)
            break
        case 1:
            addRow(type: RowType(rawValue: 1)!)
            break
        case 2:
            addRow(type: RowType(rawValue: 2)!)
            break
        case 3:
            addRow(type: RowType(rawValue: 3)!)
            break
        case 4:
            addRow(type: RowType(rawValue: 4)!)
            break
        case 5:
            addRow(type: RowType(rawValue: 5)!)
            break
        default:
            break
        }
    }
    
    var lastUpdateTimeInterval = TimeInterval()
    var lastYeldTimeInterval = TimeInterval()
    
    // Esta função mapeia o tempo para ficar enviando os obstáculos para o jogador
    
    func updateWithTimeSinceLastUpdaten (timeSinceLastUpdate: CFTimeInterval) {
        lastYeldTimeInterval += timeSinceLastUpdate
        if lastYeldTimeInterval > 0.6  {
            lastYeldTimeInterval = 0
            addRandomRow()
            
        }
    }
    
    // Enquanto o usuário estiver tocando na tela, eu utilizo a intensidade deste toque para abrir de forma simétrica o player
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let maximumPossibleForce = touch.maximumPossibleForce
            let force = touch.force
            let normalizedForce = force/maximumPossibleForce
            
            player.position.x = (self.size.width / 2) - normalizedForce * (self.size.width/2 - 25)
            player2.position.x = (self.size.width / 2) + normalizedForce * (self.size.width/2 - 25)
            
        }
    }
    
    // Quando ele para de tocar na tela eu reseto a posição inicial do player
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetPlayerPosition()
    }
    
    // Função que coloca o player na sua posição inicial
    
    func resetPlayerPosition() {
        player.position = initialPlayerPosition
        player2.position = initialPlayerPosition
    }
    
    // Função para mepear o tempo
    
    override func update(_ currentTime: TimeInterval) {
        var timeSinceLastUpdate = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime

        if timeSinceLastUpdate > 1 {
            timeSinceLastUpdate = 1/60
            lastUpdateTimeInterval = currentTime
        }

        updateWithTimeSinceLastUpdaten(timeSinceLastUpdate: timeSinceLastUpdate)
    }
}

// Extensão da classe GameScene que implementa os contatos entre os corpos do jogo
// No jogo só existe contato obstáculo-laser e obstáculo-player

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        // Verificando se ocorreu o contato obstáculo-player
        if contact.bodyA.node?.name == "Player" || contact.bodyB.node?.name == "Player" {
            run(gameOverSound) // Tocar o som da game over
            notification.notificationOccurred(.error) // Vibração
            lifes -= 1 // Decrementar uma vida
            // Lógica para ir decrementando as vidas da tela até culminar em game over
            if lifes == 2 {
                lifeThree.isHidden = true
            } else if lifes == 1 {
                lifeTwo.isHidden = true
            } else {
                // Verifica se a pontuação atual é maior que o record
                if (score > record) {
                    self.record = score // Atribui o novo score ao record
                    UserDefaults.standard.set(self.record, forKey: "Record") // Salva com User Defaults o novo record
                    recordString = "Novo Record: \(record)" // Envia para a tela de game over a String com novo record
                    print(recordString) // Print novo recorde no console no Xcode
                } else {
                    recordString = "Record: \(record)"
                }
                
                // Delegate que envia pontuação atual e recorde para tela de game over
                scoreDelegate?.recebeScore(score: score)
                recordDelegate?.recebeRecord(record: recordString)
                showGameOver()

            }
            
            // Verificando contato obstáculo-laser
    
        } else if contact.bodyA.node?.name == "Laser" || contact.bodyB.node?.name == "Laser"{
            self.score += 1 // Incremento da pontuação
            self.label.text = "Score: \(score)"
            // Vai tocar um som de bonus a cada 5 obstáculos superamos
            if score % 5 == 0 {
                run(scoreSound) // Toca música de score
            }
        }
    }
    
    // Função que apresenta tela de game over
    
    func showGameOver () {
        let transition = SKTransition.fade(withDuration: 0.5)
        self.view?.presentScene(gameOverScene, transition: transition)
    }

}
