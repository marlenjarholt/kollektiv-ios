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
    
    static let reusableIdentifier = String.init(describing: RegistrationCell.self)
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
            let padding: CGFloat = 16

            informationLabel.top == cell.top
            informationLabel.left == cell.left + padding
            informationLabel.bottom == cell.bottom
            
            userInput.top == cell.top
            userInput.left == informationLabel.right + padding
            userInput.right == cell.right - padding
            userInput.bottom == cell.bottom
        }
    }
    
    private func bindStyles(){
        userInput.textAlignment = .right
        userInput.autocorrectionType = .no
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userInput.resignFirstResponder()
        return true
    }
}
