//
//  MovieDay.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 15.02.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation

struct MovieDay: Decodable {
    var movies: [Movie]
    var dateString: String
    var date: Date {
        get {
            return DateUtils.stringToDate(dateString: self.dateString)
        }
        set {
            self.dateString = DateUtils.dateToLiteralString(date: newValue)
        }
    }
}
