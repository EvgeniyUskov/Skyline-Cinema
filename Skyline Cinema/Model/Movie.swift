//
//  Movie.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 14.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation
import RealmSwift

class Movie: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var kinopoiskId: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var descript: String = ""
    @objc dynamic var rate: Double = 0.00
    @objc dynamic var checked: Bool = false
    @objc dynamic var date: Date = Date()
}
