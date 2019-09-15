//
//  RegistrationViewController.swift
//  kollektiv-ios
//
//  Created by Simen Fonnes & Marlen Jarholt on 15/09/2019.
//  Copyright © 2019 Simen Fonnes & Marlen Jarholt. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController{
    
    var registerButton: UIButton!
    var logInButton: UIButton!
    var buttonBox: UIView!
    let buttonHeigth: CGFloat = 68
    let buttonWidth: CGFloat = 238
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bindStyles()
    }
    
    private func setupViews(){
        let buttonMargin: CGFloat = 40
        let horizontalCenter = UIScreen.main.bounds.width / 2
        let verticalCenter = UIScreen.main.bounds.height / 2
        let buttonBoxHeight = buttonHeigth * 2 + buttonMargin
        
        buttonBox = UIView.init(
            frame: CGRect.init(
                x: horizontalCenter - buttonWidth / 2,
                y: verticalCenter - buttonBoxHeight / 2,
                width: buttonWidth,
                height: buttonBoxHeight))
        
        registerButton = makeButton(name: "Registrer", y: 0)
        logInButton = makeButton(name: "Logg inn", y: buttonHeigth + buttonMargin)
        
        buttonBox.addSubview(registerButton)
        buttonBox.addSubview(logInButton)
        
        view.addSubview(buttonBox)
    }
    
    private func bindStyles(){
        view.backgroundColor = .white
    }
    
    private func makeButton(name: String, y: CGFloat) -> UIButton{
        
        let button = UIButton.init(
            frame: CGRect.init(x: 0, y: y, width: buttonWidth, height: buttonHeigth))
        button.setTitle(name, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = Colors.mainColor
        button.layer.cornerRadius = buttonHeigth/2
        
        return button
    }
}
