//
//  SettingsViewController.swift
//  Tic-Tac-Toe
//
//  Created by Paloma Bispo on 24/02/19.
//  Copyright © 2019 Paloma Bispo. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    //used to test the settings options
    enum Options {
        case sound // sound option
        case onePlayer // 1 player option
        case board3 // 3x3 board option
    }

    let soundButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sound", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = UIColor().borderButton().cgColor
        button.sizeToFit()
        button.layer.borderWidth = 4
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(soundAction), for: .touchUpInside)
        return button
    }()
    let onePlayerButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.setTitle("1 Player", for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = UIColor().borderButton().cgColor
        button.layer.borderWidth = 4
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playerAction), for: .touchUpInside)
        return button
    }()
    let twoPlayerButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.setTitle("2 Player", for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = UIColor().borderButton().cgColor
        button.layer.borderWidth = 4
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playerAction), for: .touchUpInside)
        return button
    }()
    let board3Button: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.setTitle("3x3 Board", for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = UIColor().borderButton().cgColor
        button.layer.borderWidth = 4
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(boardAction), for: .touchUpInside)
        return button
    }()
    let board4Button: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.setTitle("4x4 Board", for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = UIColor().borderButton().cgColor
        button.layer.borderWidth = 4
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(boardAction), for: .touchUpInside)
        return button
    }()
    let closeButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitle("X", for: .normal)
        button.backgroundColor = UIColor().redClose()
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return button
    }()
    let imageTitle: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "settingsTitle")
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        addSubviews()
        constraintsSetup()
    }
    
    private func initialSetup(){
        //configuring the options that is selected
        changeBackground(ofOption: .board3)
        changeBackground(ofOption: .onePlayer)
        changeBackground(ofOption: .sound)
    }
    
    private func addSubviews(){
        self.view.addSubview(soundButton)
        self.view.addSubview(onePlayerButton)
        self.view.addSubview(twoPlayerButton)
        self.view.addSubview(board3Button)
        self.view.addSubview(board4Button)
        self.view.addSubview(closeButton)
        self.view.addSubview(imageTitle)
        
    }
    private func constraintsSetup(){
        guard let superview = closeButton.superview else {return}
        //closeButton
        closeButton.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        closeButton.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor, multiplier: 1.0).isActive = true
        
        //imageTitle
        imageTitle.leadingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: 4).isActive = true
        imageTitle.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: -16).isActive = true
        imageTitle.trailingAnchor.constraint(greaterThanOrEqualTo: superview.trailingAnchor, constant: -16).isActive = true
        imageTitle.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: 0.12).isActive = true
        
//         soundButton
        soundButton.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 16).isActive = true
        soundButton.widthAnchor.constraint(equalTo: onePlayerButton.widthAnchor).isActive = true
        soundButton.heightAnchor.constraint(equalTo: onePlayerButton.heightAnchor, multiplier: 1.0).isActive = true
        soundButton.bottomAnchor.constraint(equalTo: onePlayerButton.topAnchor, constant: -32).isActive = true
        soundButton.topAnchor.constraint(equalTo: imageTitle.bottomAnchor, constant: superview.frame.height*0.15).isActive = true
        
        // onePlayerButton
        onePlayerButton.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 16).isActive = true
        onePlayerButton.topAnchor.constraint(equalTo: soundButton.bottomAnchor, constant: -32).isActive = true
        onePlayerButton.trailingAnchor.constraint(equalTo: twoPlayerButton.leadingAnchor, constant: -8).isActive = true
        onePlayerButton.widthAnchor.constraint(equalTo: twoPlayerButton.widthAnchor, multiplier: 1.0).isActive = true
        onePlayerButton.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: 0.07).isActive = true
        
//        // twoPlayerButton
        twoPlayerButton.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -16).isActive = true
        twoPlayerButton.centerYAnchor.constraint(equalTo: onePlayerButton.centerYAnchor).isActive = true
        twoPlayerButton.heightAnchor.constraint(equalTo: onePlayerButton.heightAnchor, multiplier: 1.0).isActive = true
        
//        // board3Button
        board3Button.topAnchor.constraint(equalTo: onePlayerButton.bottomAnchor, constant: 32).isActive = true
        board3Button.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 16).isActive = true
        board3Button.trailingAnchor.constraint(equalTo: board4Button.leadingAnchor, constant: -8).isActive = true
        board3Button.widthAnchor.constraint(equalTo: board4Button.widthAnchor, multiplier: 1.0).isActive = true
        board3Button.heightAnchor.constraint(equalTo: onePlayerButton.heightAnchor, multiplier: 1.0).isActive = true
        
//        // board4Button
        board4Button.topAnchor.constraint(equalTo: board3Button.topAnchor).isActive = true
        board4Button.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -16).isActive = true
        board4Button.heightAnchor.constraint(equalTo: onePlayerButton.heightAnchor, multiplier: 1.0).isActive = true
    }
    
    private func changeBackground(ofOption option: Options){
        //change the buttons background conform what is save in userDefaults
        switch option {
        case .board3:
            let board3 = UserDefaults.standard.bool(forKey: "board3")
            board3Button.backgroundColor = board3 ? UIColor().selectedBlue() : UIColor().background()
            board4Button.backgroundColor = board3 ? UIColor().background()  : UIColor().selectedBlue()
        case .onePlayer:
            let onePlayer = UserDefaults.standard.bool(forKey: "onePlayer")
            onePlayerButton.backgroundColor = onePlayer ? UIColor().selectedBlue() : UIColor().background()
            twoPlayerButton.backgroundColor = onePlayer ? UIColor().background()  : UIColor().selectedBlue()
        case .sound:
            let soundOn = UserDefaults.standard.bool(forKey: "soundOn")
            self.view.backgroundColor = UIColor().background()
            soundButton.backgroundColor = soundOn ? UIColor().selectedBlue() : UIColor().background()
        }
    }
    
    // MARK: - Button Actions
    
    @objc func soundAction(){
        let soundOn = UserDefaults.standard.bool(forKey: "soundOn")
        UserDefaults.standard.set(!soundOn, forKey: "soundOn")
        changeBackground(ofOption: .sound)
    }
    
    @objc func playerAction(){
        let onePlayer = UserDefaults.standard.bool(forKey: "onePlayer")
        UserDefaults.standard.set(!onePlayer, forKey: "onePlayer")
        changeBackground(ofOption: .onePlayer)
    }
    
    @objc func boardAction(){
        let board3 = UserDefaults.standard.bool(forKey: "board3")
        UserDefaults.standard.set(!board3, forKey: "board3")
        changeBackground(ofOption: .board3)
    }

    @objc func closeAction(){
        self.dismiss(animated: true, completion: nil)
    }
}
