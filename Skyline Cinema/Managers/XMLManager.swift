//
//  XMLManager.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 15.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation
import SwiftyXML

class XMLManager {
    static var shared : XMLManager {
        return XMLManager()
    }
    
    private init() {}
    
    func parseRatesXML(data: Data) -> Rates? {
        if let xml = XML(data: data) {
            let kpRate = xml.kp_rating.stringValue
            let imdbRate = xml.imdb_rating.stringValue
            let rates = Rates(kpRate: kpRate, imdbRate: imdbRate)
            return rates
        }
        return nil
    }
}
