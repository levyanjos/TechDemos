//
//  GameOverScene.swift
//  TesteSpriteKit
//
//  Created by Mateus Sales on 25/02/19.
//  Copyright © 2019 Mateus Sales. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    // Ambas as variáveis são passadas de uma tela para outra por meio de delegate
    // Pontuação do jogador na atual partida
    var score = 0
    // Variável que vai armazenar o record do usuário
    var record: String = ""
    
    // Chamada para sobrescrever o construtor
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    // Sobrescrevendo o construtor padrão da classe
    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = SKColor.black // Colocando como cor de fundo da view o preto
    }
    
    override func didMove(to view: SKView) {
        let labelScore = SKLabelNode(fontNamed: "Optima-ExtraBlack") // Definindo qual a fonte
        labelScore.text = "Score: \(score)" // Atribuindo o texto que será mostrado
        labelScore.fontColor = .white // Colocando como branco a cor da label
        labelScore.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - 50) // Setando a posição da label
        addChild(labelScore) //Adcionando a label como filha da cena
        
        let label = SKLabelNode(fontNamed: "Optima-ExtraBlack") // Definindo qual a fonte
        label.text = "Game Over" // Atribuindo o texto que será mostrado
        label.fontColor = SKColor.white // Colocando como branco a cor da label
        label.position = CGPoint(x: self.size.width / 2 , y: self.size.height / 2) // Definindo a posição da label, neste caso centralizada verticalmente e horizontalmente
        addChild(label) // Adcionando a label como filha da minha cena
        
        let labelRecord = SKLabelNode(fontNamed: "Optima-ExtraBlack") // Definindo qual a fonte
        labelRecord.text = record // Atribuindo o texto que será mostrado
        labelRecord.fontColor = .white // Colocando como branco a cor da label
        labelRecord.position = CGPoint(x: self.size.width / 2 , y: self.size.height / 2 - 100) // Setando a posição da label
        addChild(labelRecord) // Adcionando a label como filha da minha cena
        
    }
    
    // Este método é chamado automicamente toda vez que ocorre um toque na tela
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let transition = SKTransition.fade(withDuration: 0.5) // Definindo qual o tipo de transição e a duração da mesma
        let gameScene = GameScene(size: self.size) // Inicializamdo minha cena com o tamanho da minha view
        self.view?.presentScene(gameScene, transition: transition) // Apresentando uma cena, você informa qual a cena e qual a transição da mesma
    }
    
}

// Delegate para receber o score da GameScene
extension GameOverScene: ScoreDelegate {
    // Recebe o score da GameScene e atribui a variável que existe nesta cena
    func recebeScore(score: Int) {
        self.score = score
    }
}

// Delegate para receber o record da GameScene
extension GameOverScene: RecordDelegate {
    // Recebe o record da GameScene e atribui a variável que existe nesta cena
    func recebeRecord(record: String) {
        self.record = record
    }
}
