//
//  Order.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 20/08/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import Foundation
import RealmSwift

class Order: Object {
    @objc dynamic var descript: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var number: Int = 0
    @objc dynamic var licensePlateNumber: String = ""
    let items = List<Item>()
    
}
