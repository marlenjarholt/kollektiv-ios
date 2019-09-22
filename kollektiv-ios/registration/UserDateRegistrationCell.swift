//
//  UserDateRegistrationCell.swift
//  kollektiv-ios
//
//  Created by Simen Fonnes & Marlen Jarholt on 22/09/2019.
//  Copyright © 2019 Simen Fonnes & Marlen Jarholt. All rights reserved.
//

import UIKit
import Cartography

class UserDateRegistrationCell: UITableViewCell{
    
    static let reusableIdentifier = String.init(
        describing: UserDateRegistrationCell.self)
    var informationLabel: UILabel!
    var dateLabel: UILabel!
    var datePicker: UIDatePicker!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
        bindStyles()
    }
    
    private func setupViews(){
        informationLabel = UILabel.init(frame: .zero)
        datePicker = UIDatePicker.init(frame: .zero)
        dateLabel = UILabel.init(frame: .zero)
        
        addSubview(informationLabel)
        addSubview(datePicker)
        addSubview(dateLabel)
        
        let marlenDate = "26.03.1998"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let initialDate = dateFormatter.date(from: marlenDate)
        
        datePicker.date = initialDate!
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        dateLabel.text = marlenDate
    }
    
    private func setupConstraints(){
        constrain(self, informationLabel, datePicker, dateLabel) {cell, informationLabel, datePicker, dateLabel in
            informationLabel.top == cell.top
            informationLabel.left == cell.left + 16
            informationLabel.height == 56
            
            dateLabel.top == cell.top
            dateLabel.right == cell.right - 16
            dateLabel.height == 56
            
            datePicker.top == informationLabel.bottom
            datePicker.left == cell.left
            datePicker.right == cell.right
            datePicker.bottom == cell.bottom
        }
    }
    
    private func bindStyles(){
        datePicker.backgroundColor = .white
        datePicker.datePickerMode = .date
        
        dateLabel.textAlignment = .right
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateLabel.text = formatter.string(from: datePicker.date)
    }
}
