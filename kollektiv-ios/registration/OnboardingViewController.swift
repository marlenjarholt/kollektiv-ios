//
//  RegistrationViewController.swift
//  kollektiv-ios
//
//  Created by Simen Fonnes & Marlen Jarholt on 15/09/2019.
//  Copyright © 2019 Simen Fonnes & Marlen Jarholt. All rights reserved.
//

import UIKit
import Cartography

class OnboardingViewController: UIViewController{
    
    var registerButton: UIButton!
    var logInButton: UIButton!
    let buttonHeigth: CGFloat = 68

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstrains()
        bindStyles()
    }
    
    private func setupViews(){
        registerButton = makeButton(name: "Registrer")
        logInButton = makeButton(name: "Logg inn")
        
        registerButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(registerButtonTapped)))
        
        view.addSubview(registerButton)
        view.addSubview(logInButton)
    }

    private func setupConstrains() {
        constrain(view, registerButton, logInButton) { view, registerButton, logInButton in
            let buttonMargin: CGFloat = 20
            let buttonWidth: CGFloat = 238

            registerButton.bottom == view.centerY - buttonMargin
            registerButton.centerX == view.centerX
            registerButton.width == buttonWidth
            registerButton.height == buttonHeigth

            logInButton.top == view.centerY + buttonMargin
            logInButton.centerX == view.centerX
            logInButton.width == buttonWidth
            logInButton.height == buttonHeigth
        }
    }
    
    private func bindStyles(){
        view.backgroundColor = .white
    }
    
    private func makeButton(name: String) -> UIButton {
        let button = UIButton.init(frame: .zero)
        button.setTitle(name, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = Colors.mainColor
        button.layer.cornerRadius = buttonHeigth / 2
        
        return button
    }
    
    @objc func registerButtonTapped(){
        let backItem = UIBarButtonItem()
        backItem.title = "Tilbake"
        navigationItem.backBarButtonItem = backItem
        backItem.tintColor = .black
        navigationController?.pushViewController(UserRegistrationViewController.init(), animated: true)
    }
}
