//
//  File.swift
//  Tic-Tac-Toe
//
//  Created by Paloma Bispo on 28/02/19.
//  Copyright © 2019 Paloma Bispo. All rights reserved.
//

import Foundation
import UIKit

// From scene tells the controller to present or dismiss
protocol PresentingProtocol {
    func dismissCurrent() // used to tell the controller to dismiss yourself
    func present(alert: UIAlertController) // used to tell the controller to present a alert
}
