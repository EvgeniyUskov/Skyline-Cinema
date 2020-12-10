//
//  TimeTableViewModel.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 09.12.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation

protocol TimeTableViewModelProtocol {
    var movieDays: [MovieDayViewModel] {get}
}

class TimeTableViewModel: TimeTableViewModelProtocol {
    var movieDays: [MovieDayViewModel]
    
    init(movieDays: [MovieDay]) {
        self.movieDays = [MovieDayViewModel]()
        movieDays.forEach {
            self.movieDays.append(MovieDayViewModel(movieDay: $0))
        }
    }
}
