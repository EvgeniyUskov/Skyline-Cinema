//
//  Event.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 16.02.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation

struct Event {
    let title: String
    let startDate: Date
    let endDate: Date

    init(title: String, startDate: Date, endDate: Date ) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
    }
}
