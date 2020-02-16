//
//  MovieDay.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 15.02.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation

struct MovieDay {
    var dateString: String
    var date: Date {
        get {
            return DateUtils.stringToDate(dateString: self.dateString)
        }
        set {
            self.dateString = DateUtils.dateToLiteralString(date: newValue)
        }
    }
    var movies: [TimeTableCellViewModel]
    
    init(date: String, movies: [Movie]) {
        self.dateString = DateUtils.dateToLiteralString(date: DateUtils.stringToDate(dateString: date))
        var movieViewModelList = [TimeTableCellViewModel]()
        for movie in movies {
            let movieViewModel = TimeTableCellViewModel(movie: movie)
            movieViewModelList.append(movieViewModel)
        }
        self.movies = movieViewModelList
    }
}
