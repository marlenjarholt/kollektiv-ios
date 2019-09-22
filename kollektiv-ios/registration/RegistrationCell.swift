//
//  RegistrationCell.swift
//  kollektiv-ios
//
//  Created by Simen Fonnes & Marlen Jarholt on 15/09/2019.
//  Copyright © 2019 Simen Fonnes & Marlen Jarholt. All rights reserved.
//

import UIKit
import Cartography

class RegistrationCell: UITableViewCell, UITextFieldDelegate {
    
    static let reusableIdentifier = String.init(
        describing: RegistrationCell.self)
    var userInput: UITextField!
    var informationLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
        bindStyles()
    }
    
    private func setupViews(){
        informationLabel = UILabel.init(frame: .zero)
        userInput = UITextField.init(frame: .zero)
        
        addSubview(informationLabel)
        addSubview(userInput)
        
        userInput.delegate = self
        userInput.returnKeyType = .done
    }
    
    private func setupConstraints(){
        constrain(self, informationLabel, userInput){cell, informationLabel, userInput in
            informationLabel.top == cell.top
            informationLabel.left == cell.left + 16
            informationLabel.bottom == cell.bottom
            
            userInput.top == cell.top
            userInput.left == informationLabel.right + 16
            userInput.right == cell.right - 16
            userInput.bottom == cell.bottom
        }
    }
    
    private func bindStyles(){
        userInput.textAlignment = .right
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userInput.resignFirstResponder()
        return true
    }
}
