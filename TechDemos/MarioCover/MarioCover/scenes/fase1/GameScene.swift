//
//  //  MyGame
//
//  Created by Ramires Moreira on 19/02/19.
//  Copyright © 2019 Ramires Moreira. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private lazy var background : SKNode  = {
        let node = self.childNode(withName: "background")!
        return node
    }()
    
    private lazy var cameraNode: SKCameraNode = {
        let camera = SKCameraNode()
        camera.position = cameraNodeInitialPosition
        return camera
    }()
    
    private lazy var  middle : CGFloat =  {
        return frame.width/2
    }()
    
    private lazy var cameraNodeInitialPosition : CGPoint = {
        let x: CGFloat = frame.width/2
        let y: CGFloat = frame.height/2
        return CGPoint(x: x , y: y)
    }()
    
    private lazy var topSpace : CGPoint = { return CGPoint(x: 0 , y: frame.height/2 - 60)}()
    
    private lazy var leftArrow : ButttonNode = {
        let button = ButttonNode(imageNamed: "left",position : topSpace )
        button.touchesBeganhandler = { touches , event in self.mario.back() }
        button.touchesEndedHandler = { touches,  event in self.mario.stop() }
        button.zPosition = 10
        return button
    }()
    
    private lazy var rightArrow : SKNode = {
        let button = ButttonNode(imageNamed: "right_arrow",position : topSpace )
        button.touchesBeganhandler = { touches , event in self.mario.foward() }
        button.touchesEndedHandler = { touches,  event in self.mario.stop() }

        return button
    }()
    
    private lazy var topArrow : ButttonNode = {
        let button = ButttonNode(imageNamed: "top_arrow",position : topSpace )
        button.touchesBeganhandler = { touches , event in self.mario.jump() }
        return button
    }()
    
    lazy var musicPlayer : AVAudioPlayer = {
        let musicURL = Bundle.main.url(forResource: "yisland", withExtension: "mp3")!
        let player = try! AVAudioPlayer(contentsOf: musicURL)
        player.numberOfLoops = -1
        player.volume = 0.2
        return player
    }()
    
    lazy var mario : Mario = {
        let m = Mario()
        m.node.position = CGPoint(x: 100, y: 100)
        return m
    }()
    
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: self.background.frame)
       
        addChild(mario.node)
        childNode(withName: "batente")!.physicsBody!.restitution = 0
        childNode(withName: "floor")!.physicsBody!.restitution = 0
        camera = cameraNode
        
        camera!.addChild(leftArrow)
        camera!.addChild(rightArrow)
        camera!.addChild(topArrow)
        cameraNode.zPosition = 5
        updateButtonPosition()
        addChild(camera!)
        musicPlayer.play()
        isUserInteractionEnabled = false
    }
    
    func updateButtonPosition()  {
        let buttonSpace : CGFloat = 20
        let borderSpace: CGFloat = 40
        leftArrow.position.x = -middle + leftArrow.frame.width
        rightArrow.position.x = leftArrow.position.x + leftArrow.frame.width + buttonSpace
        topArrow.position.x = rightArrow.position.x + frame.width - (borderSpace + buttonSpace + leftArrow.frame.width + rightArrow.frame.width )
    }

    override func update(_ currentTime: TimeInterval) {
        if !(mario.component(ofType: WalkComponent.self)?.isMoving ?? false)  {return}

        if mario.node.position.x > middle  {
            let position =  min(mario.node.position.x, background.frame.width - middle)
            let move = SKAction.moveTo(x: position, duration: 0.3)
            camera?.run(move)
        }
    }
    
    func removeButtons(){
//        cameraNode.children.forEach({$0.isHidden = true})
    }
    
    func addButtonToScreen(){
//        cameraNode.children.forEach({$0.isHidden = false})
    }
}

