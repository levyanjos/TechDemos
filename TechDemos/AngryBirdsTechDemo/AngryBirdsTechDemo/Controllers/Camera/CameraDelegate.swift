//
//  CameraDelegate.swift
//  AngryBirdsTechDemo
//
//  Created by Levy Cristian  on 28/02/19.
//  Copyright © 2019 Levy Cristian . All rights reserved.
//

import UIKit

protocol SKTilemapCameraDelegate : class {
    
    func didUpdatePosition(position: CGPoint, scale: CGFloat, bounds: CGRect)
    func didUpdateZoomScale(position: CGPoint, scale: CGFloat, bounds: CGRect)
    func didUpdateBounds(position: CGPoint, scale: CGFloat, bounds: CGRect)
}
