//
//  AddressRequest.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 20.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation

struct AddressRequest: Encodable {
    var city: String
    
    init (city: String) {
        self.city = city
    }
}
