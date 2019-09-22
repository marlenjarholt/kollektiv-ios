//
//  OnboardCollectiveViewController.swift
//  kollektiv-ios
//
//  Created by Simen Fonnes & Marlen Jarholt on 22/09/2019.
//  Copyright © 2019 Simen Fonnes & Marlen Jarholt. All rights reserved.
//

import UIKit

class OnboardCollectiveViewController: UIViewController{
    
    var registerButton: UIButton!
    var newButton: UIButton!
    var buttonBox: UIView!
    let buttonHeigth: CGFloat = 68
    let buttonWidth: CGFloat = 238
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
        print(user)
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
        
        registerButton = makeButton(name: "Meld inn i kollektiv", y: 0)
        newButton = makeButton(name: "Lag nytt kollektiv", y: buttonHeigth + buttonMargin)
        
        newButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(newButtonTapped)))
        
        buttonBox.addSubview(registerButton)
        buttonBox.addSubview(newButton)
        title = "Velkommen, \(user.name)"
        
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
    
    @objc func newButtonTapped(){
        let backItem = UIBarButtonItem()
        backItem.title = "Tilbake"
        navigationItem.backBarButtonItem = backItem
        backItem.tintColor = .black
        navigationController?.pushViewController(CollectiveRegistrationViewController.init(user: user), animated: true)
        
    }
    
}
