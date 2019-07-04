//
//  Order.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 03/07/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import Foundation
// Singleton example
//struct Settings {
//    static let shared = Settings()
//    var username: String?
//    
//    private init() { }
//}

class Order {
    var id: Int = 0
    var licensePlateNumber: String = ""
    var itemsArray: [Item] = [Item]()
}
