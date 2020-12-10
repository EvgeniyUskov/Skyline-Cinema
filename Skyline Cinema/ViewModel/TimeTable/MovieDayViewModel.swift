//
//  MovieDayViewModel.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 09.12.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation

protocol MovieDayViewModelProtocol {
    var date: String {get}
    var movies: [MovieViewModelProtocol] {get}
}

class MovieDayViewModel: MovieDayViewModelProtocol {
    private var movieDay: MovieDay
    
    var date: String {
        return movieDay.dateString
    }
    
    var movies: [MovieViewModelProtocol]
    
    init(movieDay: MovieDay) {
        self.movieDay = movieDay
        self.movies = [MovieViewModel]()
        
        movieDay.movies.forEach{
            self.movies.append(MovieViewModel(movie: $0))
        }
    }
}
