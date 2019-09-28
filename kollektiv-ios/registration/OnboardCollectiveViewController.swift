//
//  OnboardCollectiveViewController.swift
//  kollektiv-ios
//
//  Created by Simen Fonnes & Marlen Jarholt on 22/09/2019.
//  Copyright © 2019 Simen Fonnes & Marlen Jarholt. All rights reserved.
//

import UIKit
import Cartography

class OnboardCollectiveViewController: UIViewController{
    
    var registerButton: UIButton!
    var newButton: UIButton!
    let buttonHeigth: CGFloat = 68
    var user: User
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, user: User) {
        self.user = user
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(user) //husk å slette
        setupViews()
        setupConstrains()
        bindStyles()
    }
    
    private func setupViews(){
        registerButton = makeButton(name: "Meld inn i kollektiv")
        newButton = makeButton(name: "Lag nytt kollektiv")
        
        newButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(newButtonTapped)))
        
        view.addSubview(registerButton)
        view.addSubview(newButton)
        title = "Velkommen, \(user.name)"
    }
    
    private func bindStyles(){
        view.backgroundColor = .white
    }

    private func setupConstrains() {
        constrain(view, registerButton, newButton) { view, registerButton, newButton in
            let buttonMargin: CGFloat = 20
            let buttonWidth: CGFloat = 238

            newButton.bottom == view.centerY - buttonMargin
            newButton.centerX == view.centerX
            newButton.width == buttonWidth
            newButton.height == buttonHeigth

            registerButton.top == view.centerY + buttonMargin
            registerButton.centerX == view.centerX
            registerButton.width == buttonWidth
            registerButton.height == buttonHeigth
        }
    }
    
    private func makeButton(name: String) -> UIButton{
        let button = UIButton.init(frame: .zero)
        button.setTitle(name, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = Colors.mainColor
        button.layer.cornerRadius = buttonHeigth / 2
        
        return button
    }
    
    @objc func newButtonTapped(){
        let backItem = UIBarButtonItem()
        backItem.title = "Tilbake"
        navigationItem.backBarButtonItem = backItem
        backItem.tintColor = .black
        navigationController?.pushViewController(CollectiveRegistrationViewController.init(user: user), animated: true)
    }
}
