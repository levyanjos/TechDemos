//
//  SpriteSheet.swift
//  MyGame
//
//  Created by Ramires Moreira on 14/03/19.
//  Copyright © 2019 Ramires Moreira. All rights reserved.
//

import SpriteKit


struct Position : Equatable {
    /// a linha correspondente em um SpriteSheet
    let row: Int
    /// a coluna correspondente em um SpriteSheet
    let column: Int
}


/// SpriteSheet é uma classe que facilita o trablaho com sprites sheet, que é uma
/// imagem que contem um conjunto de outras imagens.
class SpriteSheet {
    
    /// contem uma referência para a imagem que contém o sprite sheet completo
    let sheet : SKTexture
    
    /// quantidade de linhas no sprite sheet
    let rows : Int
    
    /// quantidade de colunas no sprite sheet
    let columns : Int
    
    /// handler que determina quando um sprite deve ser excluído
    var excludeRectWhen: ((Position) -> Bool)?
    
    /// a largura ocupada por cada sprite individualmente
    private lazy var width : CGFloat = {
       return 1.0/CGFloat(columns)
    }()

    /// a altura ocupada por cada sprite individualmente
    private lazy var height : CGFloat = {
        return 1.0/CGFloat(rows)
    }()
    
    
    /// Cria um SpriteSheet
    ///
    /// - Parameters:
    ///   - imageNamed: nome da imagem que está no xcassets
    ///   - rows: numero de linhas na imagem
    ///   - columns: numero de colunas na imagem
    ///   - excludeRectWhen: condição para excluir uma determinada posição do sprite
    init(imageNamed : String, rows : Int, columns: Int, excludeRectWhen: ((Position) -> Bool)? = nil  ) {
        sheet = SKTexture(imageNamed: imageNamed)
        self.rows = rows
        self.columns = columns
        self.excludeRectWhen = excludeRectWhen
    }
    
    /// Retorna um SKtexture
    ///
    /// - Parameters:
    ///   - row: um numero inteiro que representa a coluna do sprite desejado
    ///   - column: um numero inteiro que representa a coluna do sprite desejado
    /// - Returns: SKTexture com a imagem correspondente da linha e coluna do sprite
    func textureFor(row: Int, column: Int) -> SKTexture {
        let xPosition = CGFloat(column) * width
        let yPosition = CGFloat(rows - 1 - row) * height //para fazer iniciar por cima
        let rect = CGRect(x: xPosition, y: yPosition, width: width , height: height)
        return SKTexture(rect: rect, in: sheet)
    }
    
    
    /// Todos os sprites que estão na imagem com exceção aos que foram
    /// excluidos pela função
    ///  ```excludeRectWhen: ((Position) -> Bool)?```
    ///
    /// - Returns: um array com todos os sprites da imagem
    func allTxtures() -> [SKTexture] {
        var textures = [SKTexture]()
        for row in 0...(rows - 1) {
            for col in 0...(columns - 1) {
                if excludeRectWhen?(Position(row: row, column: col) ) ?? false {
                    continue
                }
                textures.append(textureFor(row: row, column:col ))
            }
        }
        return textures
    }
}

