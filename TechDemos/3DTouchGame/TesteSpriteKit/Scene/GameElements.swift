//
//  GameElements.swift
//  TesteSpriteKit
//
//  Created by Mateus Sales on 25/02/19.
//  Copyright © 2019 Mateus Sales. All rights reserved.
//

import SpriteKit

//Definindo máscaras de colisão dos objetos que estão na tela
struct CollisionBitMask {
    static let Player: UInt32 = 1 // Player colide com os obstáculos neste caso até dar game over
    static let Obstacle: UInt32 = 2 // Obstáculo colide com o laser Score, cada vez que eles colidirem a variável score é incrementada
    static let Score: UInt32 = 4 // Define a categoria do objeto laser, que fica invisével na altura do player, cada vez que um obstáculo toca este laser o score do jogador é incrementado
}

// Definir o tipo do obstáculo
enum ObstacleType: Int {
    case Small = 0 // Obstáculo pequeno
    case Medium = 1 // Obstáculo médio
    case Large = 2 // Obstáculo largo
}

// Definir o tipo da linha
enum RowType: Int {
    case oneS = 0 // Um obsáculo pequeno
    case oneM = 1 // Um obstáculo médio
    case oneL = 2 // Um ostáculo largo
    case twoS = 3 // Dois obstáculos pequenos
    case twoM = 4 // Dois obstáculos médios
    case threeS = 5 // Três obstáculos pequenos
}

extension GameScene {
    
    // Função para adicionar todas as propriedades do player e colocá-lo visivel na tela e com propriedades físicas
    func addPlayer(){

        player = SKSpriteNode(color: UIColor.yellow, size: CGSize(width: 50.0, height: 50.0)) // Inicializando um sprite: quadrado de cor vermelha com tamanho 50
        player.position = CGPoint(x: self.size.width / 2, y: 350) // Setando a posição do elemento na tela, ficará bem no meio com uma altura de 350 px
        player.name = "Player" // Atribuindo um nome para o sprite, pode utilizar este nome para verificar contatos
        
        //Física do corpo
        player.physicsBody?.isDynamic = false // Setando esta propriedade para falso o corpo não sofrerá ações físicas
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size) // Criando um corpo físico para o meu objeto que é retangular
        player.physicsBody?.categoryBitMask = CollisionBitMask.Player // Define a categoria do player
        player.physicsBody?.collisionBitMask = 0 // Inicializada com zero para não colidir com ninguém
        player.physicsBody?.contactTestBitMask =  CollisionBitMask.Obstacle // Definindo categoria de contato
        
        player2 = SKSpriteNode(color: UIColor.yellow, size: CGSize(width: 50.0, height: 50.0)) // Inicializando um sprite: quadrado de cor vermelha com tamanho 50
        player2.position = CGPoint(x: self.size.width / 2, y: 350) // Setando a posição do elemento na tela, ficará bem no meio com uma altura de 350 px
        player2.name = "Player2" // Atribuindo um nome para o sprite, pode utilizar este nome para verificar contatos
        
        //Física do corpo
        player2.physicsBody?.isDynamic = false // Setando esta propriedade para falso o corpo não sofrerá ações Físicas
        player2.physicsBody = SKPhysicsBody(rectangleOf: player2.size) //Criando um corpo físico para o meu objeto que é retangular
        player2.physicsBody?.categoryBitMask = CollisionBitMask.Player
        player2.physicsBody?.collisionBitMask = 0 // Inicializada com zero para não colidir com ninguém
        player2.physicsBody?.contactTestBitMask =  CollisionBitMask.Obstacle // Define com quem meu player vai ter contato
        
        // Adicionando os players como filhos da cena
        addChild(player)
        addChild(player2)
        
        // Guarda a posição inicial do player
        initialPlayerPosition = player.position
        
    }
    
    // Função que cria o obstáculo dependendo do tipo, o tipo do obstáculo é definido pelo enum criado no inicio desta classe
    // Retorna: O bjeto criado com posição e atributos físicos
    func addObstacle (type: ObstacleType) -> SKSpriteNode {
        // Definindo inicialmente a altura do meu objeto
        // A largura é colocado como zero pois dependendo do tipo do objeto esta largura será diferente
        let obstacle = SKSpriteNode(color: UIColor.white, size: CGSize(width: 0, height: 30))
        obstacle.name = "Obstacle" // Dando um nome para o obstáculo, posso usar este nome para fazer os testes de colisão na implementação do protocolo
        // Esta propriedade é true por padrão
        obstacle.physicsBody?.isDynamic = true // Afirmando que é um corpo físico e dinâmico, logo as forças físias poderão agir sobre o mesmo
        
        switch type {
        case .Small:
            // A largura do obstáculo do tipo small é 20% do tamanho da tela
            obstacle.size.width = self.size.width * 0.2
            break
        case .Medium:
            // A largura do obstáculo do tipo small é 35% do tamanho da tela
            obstacle.size.width = self.size.width * 0.35
            break
        case .Large:
            // A largura do obstáculo do tipo small é 75% do tamanho da tela
            obstacle.size.width = self.size.width * 0.75
            break
        }
        
        obstacle.position = CGPoint(x: self.size.width / 2, y: self.size.height + obstacle.size.height) // Definindo a posição inicial
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size) // Definindo o corpo físico
        obstacle.physicsBody?.categoryBitMask = CollisionBitMask.Obstacle // Definindo qual sua categoria
        obstacle.physicsBody?.contactTestBitMask = CollisionBitMask.Score // Definindo a categoria de contato
        obstacle.physicsBody?.collisionBitMask = 0 // Inicializada com zero para não colidir com outros objetos
        return obstacle // Retornando o obstáculo
    }
    
    // Função para criar o tipo de linha que define quantos(1, 2 ou 3) e qual o tipo (pequeno, médio ou largo) do objeto
    
    func addRow (type: RowType) {
        
        // Constande criada para que os objetos saião abaixo das vidas
        let dif = CGFloat(integerLiteral: 200)
        
        switch type {
        case .oneS:
            // Criando o obstáculo SKSpriteNode já que é isto que minha função retorna
            // Definindo qual o modelo do mesmo
            let obst = addObstacle(type: .Small) // Tipo do obstáculo
            obst.position = CGPoint(x: self.size.width / 2, y: obst.position.y - dif) // Posição do objeto
            addMovement(obstacle: obst) // Lógica de movimento do obstáculo
            addChild(obst) // Adicionando o obstáculo como filho da cena
            break
        case .oneM:
            // Criando o obstáculo SKSpriteNode já que é isto que minha função retorna
            // Definindo qual o modelo do mesmo
            let obst = addObstacle(type: .Medium) // Tipo do obstáculo
            obst.position = CGPoint(x: self.size.width / 2, y: obst.position.y - dif) // Posição do objeto
            addMovement(obstacle: obst) // Lógica de movimento do obstáculo
            addChild(obst) // Adicionando o obstáculo como filho da cena
            break
        case .oneL:
            // Criando o obstáculo SKSpriteNode já que é isto que minha função retorna
            // Definindo qual o modelo do mesmo
            let obst = addObstacle(type: .Large) // Tipo do obstáculo
            obst.position = CGPoint(x: self.size.width / 2, y: obst.position.y - dif) // Posição do objeto
            addMovement(obstacle: obst)// Lógica de movimento do obstáculo
            addChild(obst)
            break
        case .twoS:
            // Criando o obstáculo SKSpriteNode já que é isto que minha função retorna
            // Definindo qual o modelo do mesmo
            let obst1 = addObstacle(type: .Small) // Tipo do obstáculo
            let obst2 = addObstacle(type: .Small) // Tipo do obstáculo
            
            obst1.position = CGPoint(x: obst1.size.width + 50, y: obst1.position.y - dif) // Posição do objeto
            obst2.position = CGPoint(x: self.size.width - obst2.size.width - 50, y: obst2.position.y - dif) // Posição do objeto
            
            addMovement(obstacle: obst1) // Lógica de movimento do obstáculo
            addMovement(obstacle: obst2) // Lógica de movimento do obstáculo
            
            addChild(obst1) // Adicionando o obstáculo como filho da cena
            addChild(obst2) // Adicionando o obstáculo como filho da cena
            break
        case .twoM:
            // Criando o obstáculo SKSpriteNode já que é isto que minha função retorna
            // Definindo qual o modelo do mesmo
            let obst1 = addObstacle(type: .Medium) // Tipo do obstáculo
            let obst2 = addObstacle(type: .Medium) // Tipo do obstáculo
            
            obst1.position = CGPoint(x: obst1.size.width / 2 + 50, y: obst1.position.y - dif) // Posição do objeto
            obst2.position = CGPoint(x: self.size.width - obst2.size.width/2 - 50, y: obst2.position.y - dif) // Posição do objeto
            
            addMovement(obstacle: obst1) // Lógica de movimento do obstáculo
            addMovement(obstacle: obst2) // Lógica de movimento do obstáculo
            
            addChild(obst1) // Adicionando o obstáculo como filho da cena
            addChild(obst2) // Adicionando o obstáculo como filho da cena
            break
        case .threeS:
            // Criando o obstáculo SKSpriteNode já que é isto que minha função retorna
            // Definindo qual o modelo do mesmo
            let obst1 = addObstacle(type: .Small) // Tipo do obstáculo
            let obst2 = addObstacle(type: .Small) // Tipo do obstáculo
            let obst3 = addObstacle(type: .Small) // Tipo do obstáculo
            
            obst1.position = CGPoint(x: obst1.size.width / 2 + 50, y: obst1.position.y - dif) //Esquerda
            obst2.position = CGPoint(x: self.size.width - obst2.size.width / 2 - 50, y: obst2.position.y - dif) //Direita
            obst3.position = CGPoint(x: self.size.width / 2, y: obst3.position.y - dif) //Centro
            
            addMovement(obstacle: obst1) // Lógica de movimento do obstáculo
            addMovement(obstacle: obst2) // Lógica de movimento do obstáculo
            addMovement(obstacle: obst3) // Lógica de movimento do obstáculo
            
            addChild(obst1) // Adicionando o obstáculo como filho da cena
            addChild(obst2) // Adicionando o obstáculo como filho da cena
            addChild(obst3) // Adicionando o obstáculo como filho da cena
            
            break
        }
    }
    
    // Função que vai fazer a movimentação dos obstáculos
    
    func addMovement(obstacle: SKSpriteNode){
        // Cria um array de ações
        var actionArray = [SKAction]()
        // A duração define a velocidade do jogo, quanto menor mais rápido as barras caem
        // Este CGPoint define o destino do objeto
        actionArray.append(SKAction.move(to: CGPoint(x: obstacle.position.x, y: -obstacle.size.height), duration: 3))
        actionArray.append(SKAction.removeFromParent()) // Serve para remover os nodes que saem da tela
        obstacle.run(SKAction.sequence(actionArray)) // Serve para rodas as ações criadas sequencialmente
    }
    
    // Função para criar a label que vai mostrar os scores
    
    func addScore(){
        label = SKLabelNode(fontNamed: "Optima-ExtraBlack") // Define a fonte que será usada
        label.position = CGPoint(x: self.size.width / 2, y: self.size.height - 100) // Seta a posição da label
        label.fontSize = 35 //Tamanho da fonte
        label.text = "Score: \(score)" // A mensagem que vai ser exibida
        addChild(label) // Adicionando a label como filha da cena
    }
    
    // Função que cria o laser que vai contabilizar a pontuação do jogo
    // Explicação: O laser é um objeto invisivel que fica na mesma altura do player, toda vida que os obstáculos que caem tocar este lase será incrementada a variável score indicando para o jogador que ele conseguiu superar mais um obstáculo
    
    func addLaser(){
        laser.position = CGPoint(x: self.size.width , y: 350) // Posição do laser
        laser.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: 1)) // Definindo o corpo físico do mesmo, uma linha que tem como largura o tamanho da tela
        laser.physicsBody?.isDynamic = false // Ele não é um copor dinamico, ou seja, não sofre ação das forças físicas, fica estático no seu local
        laser.physicsBody?.categoryBitMask = CollisionBitMask.Score // Definindo sua categoria
        laser.name = "Laser" // Definindo o nome do mesmo
        addChild(laser) // Adicionando como filha na cena
    }
    
    // Função que vai adicionar e posicionar as vidas na tela do dispositivo
    
    func addLifes(){
        let tamLifes = CGSize(width: 50, height: 50)
        let positionY = self.size.height - 100
        
        lifeOne = SKSpriteNode(color: UIColor.yellow, size: tamLifes)
        lifeOne.position = CGPoint(x: 100, y: positionY)
        
        lifeTwo = SKSpriteNode(color: UIColor.yellow, size: tamLifes)
        lifeTwo.position = CGPoint(x: 200, y: positionY)
        
        lifeThree = SKSpriteNode(color: UIColor.yellow, size: tamLifes)
        lifeThree.position = CGPoint(x: 300, y: positionY)
        
        addChild(lifeOne)
        addChild(lifeTwo)
        addChild(lifeThree)
        
    }
    
}
