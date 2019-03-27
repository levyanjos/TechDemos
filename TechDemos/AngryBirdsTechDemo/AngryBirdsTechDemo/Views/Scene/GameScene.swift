//
//  GameScene.swift
//  AngryBirdsTechDemo
//
//  Created by Levy Cristian  on 19/02/19.
//  Copyright © 2019 Levy Cristian . All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    /** O node responsável pelo cenário da câmera. */
    private lazy var background: SKSpriteNode = {
        let background = SKSpriteNode(imageNamed: "background_0")
        background.position = CGPoint(x: 0 , y: 0)
        background.anchorPoint = CGPoint(x: 0, y:0)
        background.zPosition = 0
        return background
    }()
    
    /** O Limites físicos de cenário. */
    private lazy var border: SKPhysicsBody = {
        let border = SKPhysicsBody(edgeLoopFrom: background.frame)
        border.friction = 1
        return border
    }()
    
    /** O node responsável pelo estilingue. */
    private lazy var slingshot: SKSpriteNode = {
        let slingshot_1 = SKSpriteNode(imageNamed: "sling")
        slingshot_1.position = CGPoint(x: 100, y: 50)
        slingshot_1.zPosition = 2
        return slingshot_1
    }()
    
    /** O node responsável pelo pássaro. */
    private lazy var bird: Bird = {
        let projectilePath = UIBezierPath(
            arcCenter: CGPoint.zero,
            radius: Settings.Metrics.projectileRadius,
            startAngle: 0,
            endAngle: CGFloat(Double.pi * 2),
            clockwise: true
        )
        let bird = Bird(path: projectilePath, color: UIColor.orange, borderColor: UIColor.white)
        bird.position = Settings.Metrics.projectileRestPosition
        bird.zPosition = 1
        return bird
    }()
    
    /** O node responsável pelo Câmera do jogo. */
    private lazy var cameraNode: Camera = {
        let cameraNode = Camera(sceneView: self.view!, worldNode: background)
        cameraNode.position = Settings.Game.cameraOrign
        return cameraNode
    }()
    
    /** Variável de controle responsável por saber se o passago está sendo arrastado. */
    private var projectileIsDragged = false
    
    /** O node que é responsável pelo estilingue. */
    private var touchCurrentPoint: CGPoint!
    
    /** O node que é responsável pelo estilingue. */
    var touchStartingPoint: CGPoint!
    
    
    override func didMove(to view: SKView) {
        // Configurações iniciais jo jogo
        backgroundColor = .white
        anchorPoint = CGPoint(x: 0, y:0)
        self.size = background.size
        
        physicsBody = border
        physicsWorld.gravity = Settings.Game.gravity
        physicsWorld.speed = 0.5
        camera = cameraNode
        
        addChild(background)
        background.addChild(slingshot)
        background.addChild(bird)
        addChild(cameraNode)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Verifica se o pássado pode ser arrastado em uma posição
        func shouldStartDragging(touchLocation:CGPoint, threshold: CGFloat) -> Bool {
            // verifica a distância do dedo a o ponto de repouso
            let distance = fingerDistanceFromProjectileRestPosition(
                projectileRestPosition: Settings.Metrics.projectileRestPosition,
                fingerPosition: touchLocation
            )
            return distance < Settings.Metrics.projectileRadius + threshold
        }
        
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            
            // verifica se o pássaro ainda não foi arrastado e se o dento está peto do ponto de repouso para o movimento ser iniciado
            if !projectileIsDragged && shouldStartDragging(touchLocation: touchLocation, threshold: Settings.Metrics.projectileTouchThreshold)  {
                touchStartingPoint = touchLocation
                touchCurrentPoint = touchLocation
                projectileIsDragged = true
            }else{
                

            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if projectileIsDragged {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                
                // calcula a distancia do dendo em relação ao ponto de repouso para saber a forma correta de detirminar a posição correta
                let distance = fingerDistanceFromProjectileRestPosition(projectileRestPosition: touchLocation, fingerPosition: touchStartingPoint)
                
                // verifica se o dedo do usuário está dendo do limite do raio da área de arrasto. Se verdadeiro, a posição do dedo é iqual a posição do pássaro. Se falto, devemos calcular a posição relativada do passaro em relação a posição do dedo na tela.
                if distance < Settings.Metrics.rLimit  {
                    touchCurrentPoint = touchLocation
                } else {
                    touchCurrentPoint = projectilePositionForFingerPosition(
                        fingerPosition: touchLocation,
                        projectileRestPosition: touchStartingPoint,
                        rLimit: Settings.Metrics.rLimit
                    )
                }
            }
            //atualiza a posição do passaro na tela
            bird.position = touchCurrentPoint
        }else{
            //reseta o passaro para a posição inicial
            bird.physicsBody = nil
            bird.position = Settings.Metrics.projectileRestPosition
            
        }
      
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if projectileIsDragged {
            projectileIsDragged = false
            // calcula a distancia do dendo em relação ao ponto inicial e final.
            let distance = fingerDistanceFromProjectileRestPosition(projectileRestPosition: touchCurrentPoint, fingerPosition: touchStartingPoint)
            
            //verifica se a distancais enetre a posição do dedo para o pasário é maior do que a área de cancelamento de ação, se sim o impulso irá ocorrer e no caso contrário não ocorrerá.
            if distance > Settings.Metrics.projectileSnapLimit {
                //Δx
                let vectorX = touchStartingPoint.x - touchCurrentPoint.x
                //Δy
                let vectorY = touchStartingPoint.y - touchCurrentPoint.y
                bird.physicsBody = SKPhysicsBody(circleOfRadius: Settings.Metrics.projectileRadius)
                //aplica o lançamento oblico no passaro baseado no Δx, Δy e um multiplicador
                bird.physicsBody?.applyImpulse(
                    CGVector(
                        dx: vectorX * Settings.Metrics.forceMultiplier,
                        dy: vectorY * Settings.Metrics.forceMultiplier
                    )
                )
                
            } else {
                bird.physicsBody = nil
                bird.position = Settings.Metrics.projectileRestPosition
            }
        }
    }
    
}

extension GameScene {
    
    /** Calcula a distância entre o dedo e a posição de repouso do passário. */
    func fingerDistanceFromProjectileRestPosition(projectileRestPosition: CGPoint, fingerPosition: CGPoint) -> CGFloat {
        return sqrt(pow(projectileRestPosition.x - fingerPosition.x,2) + pow(projectileRestPosition.y - fingerPosition.y,2))
    }
    
    /** Calcula onde a posição do pássaro deve estar. Essa função utilizado trigonometria do triangulo retangulo para calcular a posição. */
    func projectilePositionForFingerPosition(fingerPosition: CGPoint, projectileRestPosition:CGPoint, rLimit:CGFloat) -> CGPoint {
        
        //Calcula o angulo do triângulo retangulo a partir do arco tangente 2.
        let θ = atan2(fingerPosition.x - projectileRestPosition.x, fingerPosition.y - projectileRestPosition.y)
        //Calcula o cateto oposto
        let cX = sin(θ) * rLimit
        //Calcula o cateto adjacente
        let cY = cos(θ) * rLimit
        return CGPoint(x: cX + projectileRestPosition.x, y: cY + projectileRestPosition.y)
    }
    
}


extension GameScene{
    
    
}

