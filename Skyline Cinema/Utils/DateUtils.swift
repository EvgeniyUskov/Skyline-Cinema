//
//  DateUtils.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 12.12.2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import Foundation

class DateUtils {
    static func startOfTheDay() -> Date {
            return Calendar.current.startOfDay(for: Date())
    }

    static func endOfTheDay() -> Date {
            var components = DateComponents()
            components.day = 1
            components.second = -1
            return Calendar.current.date(byAdding: components, to: startOfTheDay())!
    }

    static func startOfMonth() -> Date {
            let components = Calendar.current.dateComponents([.year, .month], from: startOfTheDay())
            return Calendar.current.date(from: components)!
    }
    
    static func endOfMonth() -> Date {
            var components = DateComponents()
            components.month = 1
            components.second = -1
            return Calendar.current.date(byAdding: components, to: startOfMonth())!
    }

    static func stringToDate (dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU_POSIX")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.date(from: dateString)!
    }
    
    static func stringToDateTime (dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU_POSIX")
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        return dateFormatter.date(from: dateString)!
    }
    
    static func dateToString (date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"

        return dateFormatter.string(from: date)
    }
    
    static func dateToLiteralString (date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMM yyyy"

        return dateFormatter.string(from: date)
    }
    
    static func dateTimeToLiteralString (date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"

        return dateFormatter.string(from: date)
    }
    
    static func stringDateTimeToLiteralString (dateString: String) -> String{
        return dateTimeToLiteralString(date: stringToDateTime(dateString: dateString))
    }
    
    static func timeString (date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "HH:mm"

        return dateFormatter.string(from: date)
    }
    
    static func dateTimeToString (date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"

        return dateFormatter.string(from: date)
    }
}

// End of day = Start of tomorrow minus 1 second
// End of month = Start of next month minus 1 second
