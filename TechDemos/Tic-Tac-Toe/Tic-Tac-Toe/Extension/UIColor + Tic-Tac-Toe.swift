//
//  UIColor + Tic-Tac-Toe.swift
//  Tic-Tac-Toe
//
//  Created by Paloma Bispo on 25/02/19.
//  Copyright © 2019 Paloma Bispo. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    
    func borderButton() -> UIColor{
        return UIColor(red: 106/255, green: 106/255, blue: 115/255, alpha: 1.0)
    }
    
    func redClose() -> UIColor{
        return UIColor(red: 236/255, green: 64/255, blue: 122/255, alpha: 1.0)
    }
    
    func orange() -> UIColor{
        return UIColor(red: 255/255, green: 144/255, blue: 0, alpha: 1.0)
    }
    
    func selectedBlue() -> UIColor{
        return UIColor(red: 38/255, green: 198/255, blue: 218/255, alpha: 1.0)
    }
}
