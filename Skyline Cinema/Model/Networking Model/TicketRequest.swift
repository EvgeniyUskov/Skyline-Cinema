//
//  TicketRequest.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 18.02.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation

struct TicketRequest: Encodable {
    let licensePlateNumber: String
    let date: String
    let movieKinopoiskId: String
    
    init (movie: MovieViewModelProtocol) {
        let defaults = UserDefaults.standard
        self.licensePlateNumber = defaults.string(forKey: Constants.propLicensePlateNumber)!
        self.date = movie.date
        self.movieKinopoiskId = movie.kinopoiskId
    }
    
    func transformToParameters() -> [String: Any] {
        var request = [String: Any]()
        request[Constants.licensePlateNumber] = self.licensePlateNumber
        request[Constants.date] = self.date
        request[Constants.kinopoiskId] = self.movieKinopoiskId
        
        return request
    }

}
