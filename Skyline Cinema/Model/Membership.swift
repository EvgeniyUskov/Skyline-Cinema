//
//  Membership.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 17.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation

struct Membership {
    var url: String
    var date: Date
    var dateString: String{
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            return formatter.string(from: date)
        }
    }
    
    init(url: String, date: Date) {
        self.url = url
        self.date = date
    }
    
    init(url: String, date: String) {
        self.url = url
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU_POSIX")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let dateFromString = dateFormatter.date(from: date) {
            self.date = dateFromString
        }
        else {
            self.date = Date()
            print("parsing Error: Invalid date: \(date)")
        }
        
    }
}
