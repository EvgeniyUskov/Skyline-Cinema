
//
//  BuyOrderViewController.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 17.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation
import WebKit
import SVProgressHUD
import YandexCheckoutPayments
import YandexCheckoutPaymentsApi

class BuyOrderViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
        
        @IBOutlet weak var titleLabel: UILabel!
        @IBOutlet weak var dateLabel: UILabel!
        
        var order: Order?
        var totalAmount: Double?
        
        override func viewDidLoad() {
            super.viewDidLoad()
//            SVProgressHUD.show()
//            let defaults = UserDefaults.standard
//            
//            let apiKey = defaults.string(forKey: Constants.propYandexApiKey)
//            let shopId = Constants.shopId
//            let amount = Amount(value: totalAmount, currency: .rub)
//
//            let inputData = TokenizationModuleInputData(
//                clientApplicationKey: apiKey,
//                shopName: Constants.shopName ,
//                purchaseDescription: "\(defaults.string(forKey: Constants.propName)) Номер: \(order.licensePlateNumber): Заказ еды",
//                amount: amount)
            
            SVProgressHUD.dismiss()
        }
        
        func performSegueToCompletedPurchase() {
            performSegue(withIdentifier: "orderCompleted", sender: self)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderCompleted" {
            let orderCompleteViewController = segue.destination as! OrderCompleteViewController
                orderCompleteViewController.order = order
        }
    }
        
    }
