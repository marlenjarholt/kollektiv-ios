//
//  User.swift
//  kollektiv-ios
//
//  Created by Simen Fonnes & Marlen Jarholt on 07/09/2019.
//  Copyright © 2019 Simen Fonnes & Marlen Jarholt. All rights reserved.
//

import UIKit

struct User {
    var name: String
    var birthDay: Date
    var nickname: String?
    var profilePic: UIImage
    var timeTable: [[String]]?
    var collective: Collective? = nil
    
    init(name: String, birthDay: Date, nickname: String?, profilePic: UIImage?) {
        self.name = name
        self.birthDay = birthDay
        self.nickname = nickname
        self.profilePic = profilePic ?? UIImage.init()
    }
    
    func age() -> String {
        let calendar = Calendar.current
        
        let now = Date()
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: birthDay)
        let date2 = calendar.startOfDay(for: now)
        
        let day = calendar.component(.day, from: birthDay)
        let month = calendar.component(.month, from: birthDay)
        let year = calendar.component(.year, from: birthDay)
        
        let components = calendar.dateComponents([.year], from: date1, to: date2)
        return "Alder: \(day). \(month) \(year) (\(components.year!))"
    }
}
