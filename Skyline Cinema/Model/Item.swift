//
//  Item.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 20/08/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var descript: String = ""
    @objc dynamic var price: Double = 0.00
    @objc dynamic var checked: Bool = false

    @objc dynamic var order: Order?
    
}
