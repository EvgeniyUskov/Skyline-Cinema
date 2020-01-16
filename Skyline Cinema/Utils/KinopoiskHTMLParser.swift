//
//  KinopoiskHTMLParser.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 16.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation
import Alamofire

class KinopoiskHTMLParser {
    func getDescription(response: DataResponse<String>) -> String {
        if let responseString = response.result.value {
            if let range = responseString.range(of: Constants.shared.kinopoiskFilmSynopsys) {
                let synopsys = String(responseString[range.upperBound ..< responseString.endIndex])
                return String(synopsys[synopsys.startIndex ..< synopsys.firstIndex(of: "<")!]).replacingOccurrences(of: "&[^;]+;", with: " ", options: String.CompareOptions.regularExpression, range: nil)
            }}
        return "Нет данных о фильме"
    }
    
    func getImageURL(response: DataResponse<String>) -> String {
        if let responseString = response.result.value {
            if let range = responseString.range(of: Constants.shared.kinopoiskFilmPoster) {
                let posterTrimmed = String(responseString[range.upperBound ..< responseString.endIndex])
                if let rangeInnerStart = posterTrimmed.range(of: "src=\"") {
                    if let rangeInnerEnd = posterTrimmed.range(of: ".jpg\"") {
                        let gg = String(posterTrimmed[rangeInnerStart.upperBound ..< rangeInnerEnd.upperBound])
                        return String(gg[gg.startIndex ..< gg.firstIndex(of: "\"")!])
                    }
                }
                
            }
        }
        return ""
    }
}
