//
//  Movie.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 14.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation
import RealmSwift

struct Movie: Decodable {
    var id: Int = 0
    var kinopoiskId: String = ""
    var title: String = ""
    var descript: String = ""
    var date: Date = Date()
}
