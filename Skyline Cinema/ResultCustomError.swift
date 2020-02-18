//
//  ResultCustomError.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 17.02.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation

enum ResultCustomError<Bool, T> {
    case success(_ : Bool)
    case failure(_ : T)
}
