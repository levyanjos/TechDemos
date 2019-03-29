//
//  Player.swift
//  Tic-Tac-Toe
//
//  Created by Paloma Bispo on 19/02/19.
//  Copyright © 2019 Paloma Bispo. All rights reserved.
//

import UIKit
import GameplayKit

// GKGameModelPlayer: Implement this protocol to describe a player in your turn-based game so that a strategist object can plan game moves.
class Player: NSObject, GKGameModelPlayer {
    
    enum Value: Int{
        case empty
        case x
        case o
        
        var name: String{
            switch self {
            case .empty:
                return ""
            case .x:
                return "X"
            case .o:
                return "O"
            }
        }
    }
    
    var playerId: Int
    var value: Value
    var name: String
    static var allPlayers = [Player(value: .x), Player(value: .o)]
    
    var opponent: Player {
        return self.value == .x ?  Player.allPlayers[1] : Player.allPlayers[0]
    }
    
    init(value: Value) {
        self.value =  value
        self.name = value.name
        playerId = value.rawValue
    }
    
    
    

}
