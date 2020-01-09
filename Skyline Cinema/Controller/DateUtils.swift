//
//  DateUtils.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 12.12.2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import Foundation

class DateUtils {
    func startOfTheDay() -> Date {
            return Calendar.current.startOfDay(for: Date())
    }

    func endOfTheDay() -> Date {
            var components = DateComponents()
            components.day = 1
            components.second = -1
            return Calendar.current.date(byAdding: components, to: startOfTheDay())!
    }

    func startOfMonth() -> Date {
            let components = Calendar.current.dateComponents([.year, .month], from: startOfTheDay())
            return Calendar.current.date(from: components)!
    }
    
    func endOfMonth() -> Date {
            var components = DateComponents()
            components.month = 1
            components.second = -1
            return Calendar.current.date(byAdding: components, to: startOfMonth())!
    }

}

// End of day = Start of tomorrow minus 1 second
// End of month = Start of next month minus 1 second
