//
//  XMLManager.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 15.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyXML

class XMLManager {
    
    func parseRatesXML(response: DataResponse<String>) -> [String: String]{
        var rates = [String: String]()
        
        do {
            let xml = try XML(string: response.result.unwrap())
            rates[Constants.kpRate] = xml.kp_rating.stringValue
            rates[Constants.imdbRate] = xml.imdb_rating.stringValue
        } catch{
            print("ERROR: CANNOT PARSE RATE XML: \(error)")
        }
        
        return rates
    }
}
