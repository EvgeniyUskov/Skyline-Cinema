//
//  ParameterEncoder.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 20.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation
import Alamofire

public protocol ParameterEncoder {
 static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}
