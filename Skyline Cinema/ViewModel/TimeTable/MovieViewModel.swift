//
//  MovieViewModel.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 10.12.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation
import UIKit

protocol MovieViewModelProtocol {
    var id: Int {get}
    var kinopoiskId: String {get}
    var title: String {get}
    var description: String {get set}
    var kpRate: String {get set}
    var imdbRate: String {get set}
    var date: String {get}
    var time: String {get}
    
    var checked: Bool {get set}
    var image: UIImage? {get set}
    var imageURL: String? {get set}
    
    func setRates(rates: Rates)
}

class MovieViewModel: MovieViewModelProtocol {
    private var movie: Movie
    
    var id: Int {
        return movie.id
    }
    var kinopoiskId: String {
        return movie.kinopoiskId
    }
    var title: String {
        return movie.title
    }
    var description: String {
        get {
            return movie.descript
        }
        set {
            movie.descript = newValue
        }
    }
    var kpRate: String
    var imdbRate: String
    //TODO: check for valid in UI
    var date: String {
        return DateUtils.dateForMovieViewModelFormattedString(date: movie.date)
    }
    var time: String {
        return DateUtils.timeString(date: movie.date)
    }

    var checked: Bool
    var image: UIImage?
    var imageURL: String?
    
    init(movie: Movie){
        self.movie = movie
        self.checked = false
        self.imdbRate = "Нет оценок"
        self.kpRate = "Нет оценок"
    }
    
    func setRates(rates: Rates) {
        guard let kpRate = rates.kpRate else {return}
        guard let doubleRate = Double(kpRate) else {return}
        self.kpRate = String.rateFormat(doubleRate)
        self.imdbRate = String(describing: rates.imdbRate)
    }
}
