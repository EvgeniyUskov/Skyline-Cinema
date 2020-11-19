//
//  CellStepperDelegate.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 10.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation

protocol CellStepperDelegate: AnyObject {
    func didChangeValue(stepperValue : Int, indexPath: IndexPath)
    
}
