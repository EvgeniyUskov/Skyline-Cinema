//
//  CartCellViewModel.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 13.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation
import UIKit

class CartCellViewModel {
    var id: Int
    var title: String
    var descript: String
    var priceDouble: Double
    var priceString: String {
        get {
                return String(Int(priceDouble))
        }
    }
    var image: UIImage?

    var count: Int
    
    init (item: Item) {
        self.id = item.id
        self.title = item.title
        self.descript = item.descript
        self.priceDouble = item.price
        self.count = 1
//        self.image = item.image
    }
}
