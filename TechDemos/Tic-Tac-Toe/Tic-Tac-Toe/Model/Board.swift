//
//  Board.swift
//  Tic-Tac-Toe
//
//  Created by Paloma Bispo on 19/02/19.
//  Copyright © 2019 Paloma Bispo. All rights reserved.
//

import UIKit
import GameplayKit

// GKGameModel - Implement this protocol to describe your gameplay model so that a strategist object can plan game moves.
class Board: NSObject {
    
    var currentPlayer = Player.allPlayers[arc4random() % 2 == 0 ? 0 : 1] //setting the currentPlayer randomly
    var n: Int = 0 // board size
    var boardValues: [[Player.Value]] = [] // the board is represented as Player.Value
    
    subscript(row: Int, col: Int) -> Player.Value {
        get {
           return boardValues[row][col]
        }
        set{
            if boardValues[row][col] == .empty{
                boardValues[row][col] = newValue
            }
        }
    }
    
    //checking if the board is full
    var isFull: Bool {
        for row in boardValues {
            for col in row {
                if col == .empty{
                    return false
                }
            }
        }
        return true
    }
    
    //getting the winner, if doesn't have, return nill
    var winningPlayer: Player? {
        var digP: [Player.Value] = [] //created to check the principal main diagonal
        var digS: [Player.Value] = [] //created to check the principal secondary diagonal
        var result: (Bool, Player?) // created to store the result of hasWinner function
        
        for row in 0..<boardValues.count{
            result = hasWinner(in: boardValues[row]) // check if has winner in row
            if result.0 {
                guard let winner = result.1 else {return nil}
                return winner
            }
            //getting col
            let col: [Player.Value] = boardValues.reduce(into: []) { (partialResult, array) in
                let value = array[row]
                partialResult.append(value)
            }
            //checking if has winner in col
            result = hasWinner(in: col)
            if result.0 {
                guard let winner = result.1 else {return nil}
                return winner
            }
            // getting diagonals
            for j in 0..<boardValues[0].count{
                if row == j{
                    digP.append(boardValues[row][j])
                }
                if row == n - 1 - j {
                    digS.append(boardValues[row][j])
                }
            }
        }
        //ckecking if has winner in diagonals
        result = hasWinner(in: digS)
        if result.0 {
            guard let winner = result.1 else {return nil}
            return winner
        }
        result = hasWinner(in: digP)
        if result.0 {
            guard let winner = result.1 else {return nil}
            return winner
        }
        return nil
    }
    
    init(n: Int) {
        super.init()
        self.n = n
        self.custonInit()
    }
    
    // initialize my boardValues with empty
    func custonInit(){
        for i in 0..<n{
            boardValues.append([])
            for _ in 0..<n {
                boardValues[i].append(.empty)
            }
        }
    }
    
    //clear my boardValues
    func clear() {
        for row in 0..<boardValues.count{
            for col in 0..<boardValues[row].count{
                self[row, col] = .empty
            }
        }
    }
    
    //ckeck if has winner in a vector. This functions is used to suport winningPlayer
    private func hasWinner(in vector : [Player.Value]) -> (hasWinner: Bool, player: Player?){
        let aux = vector[0]
        if aux == .empty {
            return (false, nil)
        }
        for i in 1..<vector.count {
            if vector[i] != aux {
                return (false, nil)
            }
        }
        guard let index = Player.allPlayers.index(where: { player -> Bool in
            return player.value == aux
        }) else {return (false, nil)}
        return (true, Player.allPlayers[index])
    }

}

extension Board: GKGameModel{
    
    var activePlayer: GKGameModelPlayer?{
        return currentPlayer
    }
    
    var players: [GKGameModelPlayer]?{
        return Player.allPlayers
    }
    
    //GKGameModel requires conformance to NSCopying because the strategist evaluates moves against copies of the game
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Board(n: self.n)
        copy.setGameModel(self)
        return copy
    }
    
    func isWin(for player: GKGameModelPlayer) -> Bool{
        guard let player = player as? Player else {return false}
        if let winner = self.winningPlayer {
            return winner == player
        }else{
            return false
        }
    }
    //assign a score to the move
    func score(for player: GKGameModelPlayer) -> Int {
        guard let player = player as? Player else {
            return Move.score.none.rawValue
        }
        if isWin(for: player) {
            return Move.score.win.rawValue
        } else {
            return Move.score.none.rawValue
        }
    }
    
    //lets GameplayKit update your game model with the new state after it makes a decision.
    func setGameModel(_ gameModel: GKGameModel) {
        if let board = gameModel as? Board {
            boardValues = board.boardValues
        }
    }
    //getting the possible moves in this game state
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        var possiblesMoves: [Move] = []
        guard let player = player as? Player else {return nil}
        if isWin(for: player) {
            return nil
        }
        for row in 0..<boardValues.count{
            for col in 0..<boardValues[0].count{
                if boardValues[row][col] == .empty {
                    let move = Move(coordinate: CGPoint(x: row, y: col))
                    possiblesMoves.append(move)
                }
            }
        }
        return possiblesMoves
    }
    
    //GameplayKit calls apply(_:) after each move selected by the strategist so you have the chance to update the game state
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        guard let move = gameModelUpdate as? Move else {return}
        self[Int(move.coordinate.x), Int(move.coordinate.y)] = currentPlayer.value
        currentPlayer = currentPlayer.opponent
    }
}
