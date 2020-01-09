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
    //MARK: Order States
    let INITIALIZED = "INITIALIZED"
    let ORDERED = "ORDERED"
    let COMPLETED = "COMPLETED"
    let REFUSED = "REFUSED"
    
    @objc dynamic var descript: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var number: Int = 0
    @objc dynamic var licensePlateNumber: String = ""
    @objc dynamic var state: String = ""
    let items = List<Item>()
    
}
