//
//  TimeTableCellViewModell.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 14.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation
import UIKit

class TimeTableCellViewModel {
    var id: Int
    var kinopoiskId: String
    var title: String
    var descript: String
    var date: String
    var rateKp: String
    var rateImdb: String
    var image: UIImage?
    var imageURL: String?

    init (movie: Movie) {
        self.id = movie.id
        self.kinopoiskId = movie.kinopoiskId
        self.title = movie.title
        self.descript = movie.descript
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        self.date = formatter.string(from: movie.date)
        self.rateKp = Constants.noRates
        self.rateImdb = Constants.noRates
//        self.image = movie.image
    }
    
    func setRates(rates: [String: String]) {
        if let kpRate = rates[Constants.kpRate] {
            self.rateKp = kpRate
        }
        if let imdbRate = rates[Constants.imdbRate] {
            self.rateImdb = imdbRate
        }
    }
    
    func setDetailsFromWiki(details: [String: String]) {
        if let descript = details[Constants.description] {
            self.descript = descript
        }
        if let imageURL = details[Constants.imageURL] {
            self.imageURL = imageURL
        }
    }
}
