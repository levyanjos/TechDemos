//
//  ButtonNode.swift
//  MyGame
//
//  Created by Ramires Moreira on 12/03/19.
//  Copyright © 2019 Ramires Moreira. All rights reserved.
//

import SpriteKit

class ButttonNode: SKSpriteNode {

    var touchesBeganhandler : ((Set<UITouch>, UIEvent?) -> Void)?
    var touchesEndedHandler : ((Set<UITouch>, UIEvent?) -> Void)?
    var touchesMovedHandler : ((Set<UITouch>, UIEvent?) -> Void)?
    
    convenience init(imageNamed : String, position: CGPoint){
        self.init(imageNamed: imageNamed)
        size = CGSize(width: 60, height: 60)
        self.position = position
        zPosition = 10
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        performe(touches, with: event, handler: touchesBeganhandler)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        performe(touches, with: event, handler: touchesEndedHandler)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        performe(touches, with: event, handler: touchesMovedHandler)
    }
    
    private func performe( _ touches: Set<UITouch>, with event: UIEvent?, handler : ((Set<UITouch>, UIEvent?) -> Void)? ){
        touches.forEach { touch in
            guard let parent = self.parent else {return}
            let location = touch.location(in: parent)
            if contains(location) {
                handler?(touches,event)
            }
        }
    }
    
    
}
