//
//  Item.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 20/08/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import Foundation

struct Item: Decodable {
    var id: Int = 0
    var category: String = ""
    var title: String = ""
    var descript: String = ""
    var price: Double = 0.00
}
