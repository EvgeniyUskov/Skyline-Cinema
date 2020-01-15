//
//  Observable.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 13.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation
// TODO delete this
class Observable<T> {
    var value: T {
        didSet {
            DispatchQueue.main.async {
                self.valueChanged?(self.value)
            }
        }
    }
    var valueChanged: ((T) -> Void)?
    
    init (val: T){
        self.value = val
    }
}
