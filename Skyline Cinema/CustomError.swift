//
//  CustomError.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 17.02.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation

enum CustomError: Error {
    case calendarAccessDeniedOrRestricted
    case eventAlreadyExistsInCalendar
    case eventNotAddedToCalendar
}
