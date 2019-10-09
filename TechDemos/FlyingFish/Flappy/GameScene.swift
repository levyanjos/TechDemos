//
//  GameScene.swift
//  Flappy
//
//  Created by Mateus Sales on 04/02/19.
//  Copyright © 2019 Mateus Sales. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var floor: SKSpriteNode! // Variável que representa o chão
    var intro: SKSpriteNode! // Variável que representa a tela de introdução
    var player: SKSpriteNode! // Variável que representa o player
    
    var gameArea: CGFloat = 410.0 // Área jogável
    var velocity: Double = 100.0 // Constante de velocidade
    
    var gameFinished = false // Flag para sinalizar que o jogo foi finalizado
    var gameStarted = false // Flag para sinalizar que o jogo foi iniciado
    var restart = false // Controla se o jogo pode ser reiniciado ou não
    
    var scoreLabel: SKLabelNode! // Label que será mostrada na parte superior indicando quantos obstáculos foram superados
    var score: Int = 0 // Pontuação do usuário, contabilizada pela quantidade de obstáculos superados
    var flyForce: CGFloat = 30 // Força que vai impulsionar o peixe para cima, eixo Y
   
    var playerCategory: UInt32 = 1 // Categoria do player para os testes de contato
    var enemyCategory: UInt32 = 2 // Categoria do inimigo para contatos, entende-se por inimigos o chão e os arpões
    var scoreCategory: UInt32 = 4 // Categoria do laser que vai contabilizar a pontuação do jogador
    
    var timer: Timer! // Tempo de aparecimento de um inimigo para o outro
    weak var gameViewController: GameViewController? // Instancia utilizada da controller utilizada para reestartar a cena após game over
    
    let scoreSound = SKAction.playSoundFileNamed("bonus.mp3", waitForCompletion: false) // Som que vai tocar quando o jogador superar um inimigo
    let gameOverSound = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false) // Som que vai tocar quando o jogador colidir com o inimigo
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self // Informando que esta classe implementará o protocolo SKPhysicsContactDelegate
        
        addBackground() // Adicionando uma imagem como fundo
        addFloor() // Adicionando o chão
        addIntro() // Adicionando tela de introdução
        addPlayer() // Adicionando player na cena
        moveFloor() // Movendo o chão para passar ideia de movimento
    }
    
    func addBackground(){
        let background = SKSpriteNode(imageNamed: "background") // Criando um fundo a partir de uma imagem que está nos assets
        background.position = CGPoint(x: size.width / 2, y: size.height / 2) // Posição imagem levando em consideração que a ancora é no canto esquerno na parte inferior da tela
        // O posicionamento no eixo Z mostra a profunidade e organização dos seus elementos, elementos com zPosition = 1 estão na frente de elementos com zPosition = 0, e assim sucessivamente
        background.zPosition = 0 // Siginifica que está mais no fundo
        addChild(background) // Adicionando fundo como filho da cena
    }
    
    func addFloor(){
        floor = SKSpriteNode(imageNamed: "floor") // Criando objeto a partir de uma imagem
        floor.zPosition = 2 // Definindo profundidade deste objeto na cena
        floor.position = CGPoint(x: floor.size.width/2, y: size.height - gameArea - floor.size.height/2) // Definindo a posição do objeto
        addChild(floor) // Adicionando como filho da cena
        
        // Linha invisivel que fica na parte inferior da tela para identificar o contado do player com o chão
        
        let invisibleFloor = SKNode() // Criando uma variável a partir da classe SKNode
        invisibleFloor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 1)) // Definindo o corpo físico do objeto neste caso por meio de um retângulo, que mais parece uma linha, pois possui 1px de altura e largura correspondente ao tamanho da tela do dispositivo, este objeto servirá para delimitar o contato com o player
        invisibleFloor.physicsBody?.isDynamic = false // Com esta propriedade colocada como falsa o objeto fica estático não sofrendo ação de forças externas
        invisibleFloor.physicsBody?.categoryBitMask = enemyCategory // Categoria do inimigo para fazer os testes de contato com os outros objetos no game
        invisibleFloor.physicsBody?.contactTestBitMask = playerCategory // Definindo categoria de contato do objeto
        invisibleFloor.position = CGPoint(x: size.width/2, y: size.height - gameArea) // Posição do objeto
        invisibleFloor.zPosition = 2 // Profundidade do objeto
        addChild(invisibleFloor) // Adicionando como filho da cena
        
        // Linha invisivel que fica na parte superior da tela, impedindo o player de sair dos limites da mesma
        
        let invisibleRoof = SKNode() // Criando uma variável a partir da classe SKNode
        invisibleRoof.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 1)) // Definindo o corpo físico do objeto neste caso por meio de um retângulo, que mais parece uma linha, pois possui 1px de altura e largura correspondente ao tamanho da tela do dispositivo, este objeto servirá para delimitar o contato com o player
        invisibleRoof.physicsBody?.isDynamic = false // Com esta propriedade colocada como falsa o objeto fica estático não sofrendo ação de forças externas
        invisibleRoof.position = CGPoint(x: size.width/2, y: size.height) // Posição do objeto
        invisibleRoof.zPosition = 2 // Profundidade do objeto
        addChild(invisibleRoof) // Adicionando como filho da cena
    }
    
    // Função utilizada para criar a tela de introdução do game
    
    func addIntro(){
        intro = SKSpriteNode(imageNamed: "intro") // Criando um nó a partir de uma imagem
        intro.zPosition = 3 // Definindo a profundidade do objeto
        intro.position = CGPoint(x: size.width/2, y: size.height - 210.0) // Posição do objeto
        addChild(intro) // Adicionando como filho da cena
    }
    
    // Função utilizada para criar o player
    
    func addPlayer(){
        player = SKSpriteNode(imageNamed: "player1") // Criando o player a partir de uma textura(imagem)
        player.zPosition = 4 // Definindo profundidade do objeto
        player.position = CGPoint(x: 60, y: size.height - gameArea/2) // Posição inicial do objeto
        
        var playerTextures = [SKTexture]() // Array que vai armazenar os frames que vamos utilizar para animar
        // Adicionando ao array as imagens que importamos para os Assets
        for i in 1...4 {
            playerTextures.append(SKTexture(imageNamed: "player\(i)"))
        }
        let animationAction = SKAction.animate(with: playerTextures, timePerFrame: 0.09) // Animação frame a frame com 0.09s
        let repeatAction = SKAction.repeatForever(animationAction) // Repetição "para sempre" da animação
        player.run(repeatAction) // Executar a animação
        addChild(player) // Adicionando como filho da cena
    }
    
    // Função utilizada para mover o chão
    
    func moveFloor() {
        let duration = Double(floor.size.width/2)/velocity //Fazer andar metade da largura e voltar pra onde estava
        let moveFloorAction = SKAction.moveBy(x: -floor.size.width/2, y: 0, duration: duration) // Movendo o chão
        let resetXAction = SKAction.moveBy(x: floor.size.width/2, y: 0, duration: 0) // Resetando a animação de movimento
        let sequenceAction = SKAction.sequence([moveFloorAction, resetXAction]) // Colocando em sequência as animações dando impressão de que o chão está se movimentando constantemente, isso pq a figura é simétrica
        let repeatAction = SKAction.repeatForever(sequenceAction) // Repetição constante da animação
        floor.run(repeatAction) // Executando a animação
    }
    
    
    // Esta label ficará na parte superior e mostrará para o jogador quantos obstáculos ele superou
    
    func addScore() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster") // Personalizando a fonte
        scoreLabel.fontSize = 94 // Tamanho da fonte
        scoreLabel.text = "\(score)" // Definindo o conteúdo da string
        scoreLabel.zPosition = 5 // Defininco a profundidade do objeto
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height - 100) // Posição do objeto
        scoreLabel.alpha = 0.8 // Opacidade
        addChild(scoreLabel) // Adicionando como filho da cena
    }
    
    // Função que contém toda a lógica dos inimigos
    
    func spawnEnemies() {
        let initialPosition = CGFloat(arc4random_uniform(132) + 74) // Sorteia a posição no eixo Y do inimigo
        let enemyNumber = Int(arc4random_uniform(4) + 1) // Sorteia o número do inimigo, isto definirá o modelo do mesmo
        let enemiesDistance = self.player.size.height * 2.5 // Espaço entre os inimigos
        
        let enemyTop = SKSpriteNode(imageNamed: "enemytop\(enemyNumber)") // Inimigo da parte superior construído a partir de uma imagem
        let enemyWidth = enemyTop.size.width // Largura do inimigo
        let enemyHeight = enemyTop.size.height // Altura do inimigo
        
        enemyTop.position = CGPoint(x: size.width + enemyWidth/2, y: size.height - initialPosition + enemyHeight/2) // Posição do inimigo superior
        enemyTop.zPosition = 1 // Profundidade do inimigo superior
        enemyTop.physicsBody = SKPhysicsBody(rectangleOf: enemyTop.size) // Corpo físico do inimigo superior
        enemyTop.physicsBody?.isDynamic = false // Corpo estático, não sofre ação de forças externas
        enemyTop.physicsBody?.categoryBitMask = enemyCategory // Categoria de contato do inimigo da parte superior
        enemyTop.physicsBody?.contactTestBitMask = playerCategory // Categoria de contato
        
        
        let enemyBottom = SKSpriteNode(imageNamed: "enemybottom\(enemyNumber)") // Inimigo da parte inferior construído a prtir de uma imagem
        enemyBottom.position = CGPoint(x: size.width + enemyWidth/2, y: enemyTop.position.y - enemyTop.size.height - enemiesDistance) // Posição do inimigo inferior
        enemyBottom.zPosition = 1 // Corpo físico do inimigo inferior
        enemyBottom.physicsBody = SKPhysicsBody(rectangleOf: enemyBottom.size) // Corpo físico do inimigo inferior
        enemyBottom.physicsBody?.isDynamic = false // Corpo estático, não sofre ação de forças externas
        enemyBottom.physicsBody?.categoryBitMask = enemyCategory // Categoria de contato do inimigo da parte inferior
        enemyBottom.physicsBody?.contactTestBitMask = playerCategory // Categoria de contato
        
        // Laser que vai ficar entre os dois inimigos(superior e inferior), quando identificar o contato entre o player e este laser vou incrementando a variável score
        let laser = SKNode() // Criando um nó que será o laser
        laser.position = CGPoint(x: enemyTop.position.x + enemyWidth/2, y: enemyTop.position.y - enemyTop.size.height/2 - enemiesDistance/2) // Posição do laser
        laser.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: enemiesDistance)) // Corpo físico do laser
        laser.physicsBody?.isDynamic = false // Corpo estático, não sofre ação de forças externas
        laser.physicsBody?.categoryBitMask = scoreCategory // Categoria de contato
        
        // O inimigo precisa se movimentar da parte esquerda da tela até a parte direita, o player não se movimenta no eixo X apenas no eixo Y, o que se movimenta são os inimigos e o chão dando assim a ideia de movimento
        let distance = size.width + enemyWidth // Largura da tela + largura do inimigo
        let duration = Double(distance)/velocity // Cálculo da duração do movimento
        let moveAction = SKAction.moveBy(x: -distance, y: 0, duration: duration) // Ação do que movimenta os inimigos e o laser
        let removeAction = SKAction.removeFromParent() // Quando terminar o movimento ele já estará fora da tela, então removo o mesmo
        let sequenceAction = SKAction.sequence([moveAction, removeAction]) // Ação que sequencia os movimentos
        
        enemyTop.run(sequenceAction) // Aplicando a sequencia de movimentos que foi criada ao inimigo superior
        enemyBottom.run(sequenceAction) // Aplicando a sequencia de movimentos que foi criada ao inimigo inferior
        laser.run(sequenceAction) // Aplicando a sequencia de movimentos que foi criada ao laser
        
        // Adicionando como filhos da cena
        addChild(enemyTop)
        addChild(enemyBottom)
        addChild(laser)
        
    }
    
    // Esta função será chamada sempre que o contato player-inimigo ou player-chão for identificado
    
    func gameOver(){
        timer.invalidate() // Parar o timer
        player.zRotation = 0 // Rotação no eixo Z do player
        player.texture = SKTexture(imageNamed: "playerDead") // Mudando a texrtura para uma textura de "peixinho morto"
        // Percorre todos os nós da cena e remove a ação de todos, assim o jogo fica completamente estático
        for node in self.children {
            node.removeAllActions()
        }
        player.physicsBody?.isDynamic = false // Player passa a ser um objeto estático
        gameFinished = true // Flag de game finalizado vai para verdadeiro, assim no touchesBegan(_ touches: ) podemos tomar a decisão correta
        gameStarted = false // Flag de game iniciado vai para falso
        
        // Coloca na tela a imagem de game over do game
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer) in
            let gameOverImage = SKSpriteNode(imageNamed: "GameOver.png")
            gameOverImage.size = CGSize(width: 308, height: 207)
            gameOverImage.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            gameOverImage.zPosition = 5
            self.addChild(gameOverImage)
            self.restart = true
        }
    }
    
    // Quando ele toca na tela este método é disparado
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameFinished {
            if !gameStarted {
                intro.removeFromParent() // Remove a tela de introdução da cena
                addScore()
                player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width - 42) // Inicializando corpo físico do player a partir de uma textura
                player.physicsBody?.isDynamic = true // Agora sofre a ação da gravidade
                player.physicsBody?.allowsRotation = true // Mudar o ângulo do player baseado no impulso aplicado
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: flyForce)) // Aplicando impulso no player, apenas no eixo Y
                player.physicsBody?.categoryBitMask = playerCategory // Definindo a categoria do player
                player.physicsBody?.contactTestBitMask = scoreCategory // Definindo categoria de teste de contato
                player.physicsBody?.collisionBitMask = enemyCategory // Definindo categoria de colisão
                
                gameStarted = true // Flag para sinalizar que o jogo vai iniciar
                
                // A cada 2.5 segundos aparece um novo inimigo na tela
                timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { (timer) in
                    self.spawnEnemies() // Função que tem a lógica dos inimigos
                }
            } else {
                player.physicsBody?.velocity = CGVector.zero // Definindo velocidade como zero, para não afetar no impulso que vamos aplicar no player
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: flyForce)) // Aplicando o impulso
            }
        } else {
            // Quando cair neste caso a tela que estará sendo exibida é a Game Over
            if restart { // Caso a flag de restart seja verdadeira
                restart = false // Colocamos ela para falso
                gameViewController?.presentScene() // Apresentamos a GameScene novamente e uma nova partida é iniciada
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameStarted != nil{
            // Calcula a velocidade do player no eixo Y, para rotacionar o mesmo conforme esta velocidade
            let yVelocity = player.physicsBody!.velocity.dy * 0.001 as CGFloat // Cáculo da velocidade
            player.zRotation = yVelocity // Rotação no eixo Z do player
            
        } else{
            print("Error gameStarted")
        }
    }
}

// Protocolo implementado para verificar os contatos entre os corpos existentes no jogo

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if gameStarted{ // Se o game tiver começado, verifico se existiu contato com o laser(score)
            if contact.bodyA.categoryBitMask == scoreCategory || contact.bodyB.categoryBitMask == scoreCategory {
                // Se verdadeiro incremento a variável score e emito um som, signifca que o player passou entre os dois inimigos e não tocou o chão
                score += 1
                scoreLabel.text = "\(score)"
                run(scoreSound)
                // Se o contato for com a categoria que definimos para o chão e para os inimigos, chamo instantaneamente a função de Game Over
            } else if contact.bodyA.categoryBitMask == enemyCategory || contact.bodyB.categoryBitMask == enemyCategory {
                gameOver() // Chamada para a função game over
                run(gameOverSound) // Feedback sonoro para o usuário saber que acabou de tocar em algum inimigo
            }
        }
    }
}
