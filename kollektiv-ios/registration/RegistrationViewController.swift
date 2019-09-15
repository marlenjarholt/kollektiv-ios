//
//  RegistrationViewController.swift
//  kollektiv-ios
//
//  Created by Simen Fonnes & Marlen Jarholt on 15/09/2019.
//  Copyright © 2019 Simen Fonnes & Marlen Jarholt. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController{
    
    var registerButton: UIButton!
    var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bindStyles()
    }
    
    private func setupViews(){
        registerButton = UIButton.init(
            frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
    }
    
    private func bindStyles(){
        view.backgroundColor = .white
    }
}
