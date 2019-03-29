//
//  GameScene.swift
//  Tic-Tac-Toe
//
//  Created by Paloma Bispo on 19/02/19.
//  Copyright © 2019 Paloma Bispo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var boardNode: SKSpriteNode! //node that show the board/grid
    var headerNode: SKSpriteNode! // node that goes on botton of screen to show turn's information
    var closeNode: SKSpriteNode! // node to exit screen
    var informationLabel: SKLabelNode! // userd to show turn's information
    var boardPieceNodes: [[SKSpriteNode]] = []
    
    //sound variables
    var win = SKAction.playSoundFileNamed("success.wav", waitForCompletion: false)
    var failure = SKAction.playSoundFileNamed("failure.wav", waitForCompletion: false)
    
    var strategist: Strategist!
    var board: Board! // class to manage the board, check for winner, check if it`s full, etc
    var n = 0 // the size of the board 3x3 ou 4x4
    var hasSound = true // to check if the sound is on
    var isOnePlayer: Bool! // to check if is one player mode
    var presentingProtocol: PresentingProtocol!
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        initialSetup()
        startGame()
    }
    
    private func initialSetup(){
        //getting from userDefaults the user's options
        let isBoard3 = UserDefaults.standard.bool(forKey: "board3")
        hasSound = UserDefaults.standard.bool(forKey: "soundOn")
        isOnePlayer =  UserDefaults.standard.bool(forKey: "onePlayer")
        
        //setting the size of board
        n = isBoard3 ? 3 : 4
        board = Board(n: n)
        
        //creating the minMaxStrategist
        let minMax = GKMinmaxStrategist()
        // setting the maxLookAheadDepth from the size of board
        minMax.maxLookAheadDepth = self.n == 4 ? 5 : 100
        minMax.randomSource = GKARC4RandomSource()

        strategist = Strategist(strategist: minMax, board: board)
        // setting the scene's anchorPoint
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // setting the scene's background color
        self.backgroundColor = SKColor().background()
    }
    
    private func startGame(){
        //board setup
        let nameTexture = n == 3 ? "board3" : "board4"
        
        //building the board
        let boardTexture = SKTexture(imageNamed: nameTexture)
        guard let viewFrame = view?.frame else {return}
        let widthBoard = viewFrame.width - 24
        boardNode = SKSpriteNode(texture: boardTexture, size: CGSize(width: widthBoard, height: widthBoard))
        boardNode.position = CGPoint(x: 0.0, y: 0.0)
        addChild(boardNode)
        
        //header setup
        headerNode = SKSpriteNode(color: UIColor.lightGray, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.14))
        headerNode.anchorPoint = CGPoint(x: 0.0, y: 1)
        headerNode.position.x = -viewFrame.maxX/2
        headerNode.position.y = -(viewFrame.maxY/2 - headerNode.frame.height)
        addChild(headerNode)
        
        //informationLabel setup
        informationLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        informationLabel.fontSize = 40
        informationLabel.fontColor = .white
        informationLabel.position = CGPoint(x: headerNode.frame.midX, y: headerNode.frame.midY)
        informationLabel.verticalAlignmentMode = .center
        addChild(informationLabel)
        
        //closeNode
        closeNode = SKSpriteNode(texture: SKTexture(imageNamed: "close"))
        closeNode.size = CGSize(width: 35, height: 35)
        closeNode.position.x = -(viewFrame.maxX/2 - 16)
        closeNode.position.y = viewFrame.maxY/2 - 32
        closeNode.anchorPoint = CGPoint(x: 0.0, y: 1)
        addChild(closeNode)
        
        putGamePieces()
        resetGame()
        updateGame()
    }
    
    //AI making move
    private func moveAI() {
        DispatchQueue.global().async { [unowned self] in
            let strategistTime = CFAbsoluteTimeGetCurrent()// Returns the current system absolute time.
            //getting the best move
            guard let bestCoordinate = self.strategist.bestCoordinate else {
                return
            }
            let timeExecution = CFAbsoluteTimeGetCurrent() - strategistTime
            let delayStatic = 0.75
            /*
             we use the delay to give the impression that the AI is thinking about the movement. If the board is 3x3, we get the max between the timeExecution and delayStatic, because the process is fast enough. If the board is 4x4 the process of the best move is slow, so, we get the min between timeExecution and delayStatic
            */
            let delay =  self.n == 3 ? max(timeExecution, delayStatic) : min(timeExecution, delayStatic)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.updateBoard(x: Int(bestCoordinate.x), y: Int(bestCoordinate.y))//update the board with AI's move
            }
        }
    }
    
    // to run a sound
    private func playSound(sound : SKAction){
        run(sound)
    }
    
    //before the  game start we make a grid of node. We build a node for each square in board and append in boardPieceNodes
    private func putGamePieces(){
        let cellWidth = boardNode.frame.width/CGFloat(n)
        for row in 0..<n{
            boardPieceNodes.append([])
            for col in 0..<n{
                boardPieceNodes[row].append(SKSpriteNode())
                let x = boardNode.frame.minX + (cellWidth * CGFloat(col))
                let y = boardNode.frame.maxY - (cellWidth * CGFloat(row))
                let rect = CGRect(x: x, y: y, width: cellWidth, height: cellWidth)
                let piece = SKSpriteNode(color: UIColor.clear, size: rect.size)
                piece.anchorPoint = CGPoint(x: 0.0, y: 1.0)
                piece.position = rect.origin
                boardPieceNodes[row][col] = piece
            }
        }
    }
    
    private func resetGame(){
        //remove pieces from board
        boardPieceNodes.forEach { (array) in
            array.forEach({ (node) in
                node.removeFromParent()
            })
        }
        board = Board(n: self.n)//reset the board
        strategist.board = board
        putGamePieces()
    }
    
    private func updateGame(){
        var gameOver = ""
        if let winner = board.winningPlayer, winner == board.currentPlayer {//checking if has winner and the winner is the current player
            
            //just check if is one or two players to exibe the correct menssage
            if isOnePlayer {
                gameOver = board.currentPlayer.value == .x ? "X's wins" : "You wins"
            }else{
                gameOver = "\(board.currentPlayer.name) wins"
            }
            
        }else if board.isFull {
            gameOver = "draw"
        }
        if gameOver != ""{  // if someone wins or give a tie we show the alert
            let alertGameOver = UIAlertController(title: gameOver, message: nil, preferredStyle: UIAlertController.Style.alert)
            let playAgainAction = UIAlertAction(title: "Play Again", style: UIAlertAction.Style.default) { (action) in
                self.resetGame()
                self.updateGame()
            }
            alertGameOver.addAction(playAgainAction)
            presentingProtocol.present(alert: alertGameOver)//telling the controller to present the alert
            if gameOver != "draw" && hasSound{
                if board.currentPlayer.value == .x && isOnePlayer{
                    playSound(sound: failure)
                }else{
                    playSound(sound: win)
                }
            }
            return
        }
        // if nobody wins and did not draw
        board.currentPlayer = board.currentPlayer.opponent
        
        // the AI is always the x. If is x'player and one player mode we call moveAI()
        if board.currentPlayer.value == .x && isOnePlayer{
            informationLabel.text = "\(board.currentPlayer.name)'s Turn"
            moveAI()
        }else{
            if isOnePlayer{
                informationLabel.text = "Your's Turn"
            }else{
                informationLabel.text =  "\(board.currentPlayer.name)'s Turn"
            }
        }
    }
    
    private func updateBoard(x: Int, y: Int){
        if board[x, y] != .empty { return }//checking if the move is valid
        board[x, y] = board.currentPlayer.value
        
        // getting the corresponding node in boardPieceNodes
        let node = boardPieceNodes[x][y]
        let nodePosition = node.position // saving the position
        let nodeImageName = board.currentPlayer.name
        let nodeWidth = node.frame.width - 20 // spacing between the nodes
        
        node.texture = SKTexture(imageNamed: nodeImageName) // applying the texture
        node.size = CGSize(width: nodeWidth/2, height: nodeWidth/2)//we divide by 2 to scale after
        node.position = CGPoint(x: nodePosition.x+10, y: nodePosition.y-10)
        node.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        node.run(SKAction.scale(by: 2, duration: 0.25))//scale the node just to give a good effect
        
        self.addChild(node)//adding to scene
        
        updateGame()
    }
    
    private func handle(touch: UITouch){
        //validating the touch
        if board.currentPlayer.value == .x && isOnePlayer{
            return
        }
        var piece: SKNode!
        // getting the col and row of the piece that was touched in board
        for row in 0..<n{
            for col in 0..<n{
                piece = boardPieceNodes[row][col]
                if piece.frame.contains(touch.location(in: boardNode)){
                    updateBoard(x: row, y: col)
                    return
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let possition = touch.location(in: self)
            guard let node = self.nodes(at: possition).first else {return}
            if node == boardNode{
                handle(touch: touch)
            }else if node == closeNode {
                presentingProtocol.dismissCurrent()
            }
            
        }
        
    }
}
