//
//  Order.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 20/08/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import Foundation
import RealmSwift

struct Order {
    var descript: String = ""
    var date: Date = Date()
    var number: Int = 0
    var licensePlateNumber: String = ""
    
    var items = [Item]()
    
}
