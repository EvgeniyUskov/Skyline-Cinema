//
//  OrderRequest.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 18.02.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation

struct OrderRequest: Encodable {
    let licensePlateNumber: String
    let date: String
    let itemIds: [Int]
    
    init (order: Order) {
        self.licensePlateNumber = order.licensePlateNumber
        self.date = DateUtils.dateToString(date: order.date)
        var ids = [Int]()
        
        for item in order.items {
            ids.append(item.id)
        }
        self.itemIds = ids
    }
    
    func transformToParameters() -> [String: Any] {
        
        var paramsDictionary = [String: Any]()
        paramsDictionary[Constants.licensePlateNumber] = self.licensePlateNumber
        paramsDictionary[Constants.date] = self.date
        paramsDictionary[Constants.itemIds] = self.itemIds
        
        var request = [String: Any]()
        request[Constants.orderRequest] = paramsDictionary
        return request
    }

}
