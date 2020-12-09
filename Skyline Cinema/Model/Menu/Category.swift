//
//  Category.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 14.02.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation

struct Category: Decodable {
    var name: String = ""
    var items: [Item] = [Item]()
    
    init(name: String, items: [Item]) {
        self.name = name
        self.items = items
    }
}
