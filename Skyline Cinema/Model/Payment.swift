//
//  Payment.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 11.06.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation
import YooKassaPayments
import YooKassaPaymentsApi

class Payment {
    var id: String
    var status: String
    var paid: Bool
    var amount: Amount
    var createdAt: Date
    var description: String
//    var type: String
    
    init(id: String,
         status: String,
         paid: Bool,
         amount: Amount,
         createdAt: Date,
         description: String//,
//         type: String) {
        ) {
        self.id = id
        self.status = status
        self.paid = paid
        self.amount = amount
        self.createdAt = createdAt
        self.description = description
//        self.type = type
    }
//
//    "id": "22e12f66-000f-5000-8000-18db351245c7",
//      "status": "pending",
//      "paid": false,
//      "amount": {
//        "value": "2.00",
//        "currency": "RUB"
//      },
//      "confirmation": {
//        "type": "redirect",
//        "return_url": "https://www.merchant-website.com/return_url",
//        "confirmation_url": "https://money.yandex.ru/payments/external/confirmation?orderId=22e12f66-000f-5000-8000-18db351245c7"
//      },
//      "created_at": "2018-07-18T10:51:18.139Z",
//      "description": "Заказ №72",
//      "metadata": {
//
//      },
//      "payment_method": {
//        "type": "bank_card",
//        "id": "22e12f66-000f-5000-8000-18db351245c7",
//        "saved": false
//      },
//      "recipient": {
//        "account_id": "100001",
//        "gateway_id": "1000001"
//      },
//      "refundable": false,
//      "test": false
//    }
}
