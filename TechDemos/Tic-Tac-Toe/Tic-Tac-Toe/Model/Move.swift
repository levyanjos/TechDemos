//
//  Move.swift
//  Tic-Tac-Toe
//
//  Created by Paloma Bispo on 19/02/19.
//  Copyright © 2019 Paloma Bispo. All rights reserved.
//

import UIKit
import GameplayKit

//GKGameModelUpdate - Implement this protocol to describe a move in your turn-based game so that a strategist object can plan game moves.
class Move: NSObject, GKGameModelUpdate {

    //used to assign a score to the move
    enum score: Int{
        case none = 1
        case win
    }
    
    var value: Int = 0 // to conform with the protocol. A value assigned and read by GameplayKit to rate the desirability of a move in your game.
    var coordinate: CGPoint
    
    init(coordinate: CGPoint) {
        self.coordinate = coordinate
    }
    

}
