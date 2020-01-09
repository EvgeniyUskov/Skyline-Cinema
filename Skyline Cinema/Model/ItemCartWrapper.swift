//
//  ItemCartWrapper.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 09.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation

class ItemCartWrapper {
    var count: Int = 1
    var item: Item
    
    init(item: Item) {
        self.item = item
    }
}
