//
//  URL + Extension.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 10.12.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation

extension URL {

    func appending(_ parameters: [String: String]) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        for (key, val) in parameters {
            let queryItem = URLQueryItem(name: key, value: val)
            queryItems.append(queryItem)
        }
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}
