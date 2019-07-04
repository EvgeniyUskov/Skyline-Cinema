//
//  Item.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 03/07/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import Foundation

class Item {
    var id: Int
    var description: String
    
    init(id: Int, desc: String) {
        self.id = id
        self.description = desc
    }
}
