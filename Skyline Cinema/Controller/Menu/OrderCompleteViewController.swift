//
//  OrderCompleteViewController.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 18.02.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import UIKit
import Alamofire

class OrderCompleteViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var orderIsPreparingLabel: UILabel!
    
    @IBOutlet weak var bonApetitLabel: UILabel!
    
    var order: Order?
    
    func setUIToOrderCompleted(response: OrderResponse) {
        self.headerLabel.isHidden = false
        self.orderIsPreparingLabel.isHidden = false
        self.bonApetitLabel.isHidden = false
        self.headerLabel.text = Constants.getOrderProcessedText(number: response.number)
        self.bonApetitLabel.text = Constants.bonApetit
    }
    
    func setUIToErrorMode() {
        self.headerLabel.isHidden = true
        self.orderIsPreparingLabel.isHidden = true
        self.bonApetitLabel.isHidden = false
        self.bonApetitLabel.text = Constants.bonApetitError
    }
    func hideUI() {
        self.headerLabel.isHidden = true
        self.orderIsPreparingLabel.isHidden = true
        self.bonApetitLabel.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideUI()
        if let orderLocal = order {
            if Constants.isNetworkActive {
                NetworkManager.shared.applyPayment(order: orderLocal, completion: {
                    [unowned self]
                    orderResponse in
                    if let response = orderResponse {
                        self.setUIToOrderCompleted(response: response)
                    } else {
                        setUIToErrorMode()
                    }
                })
            }
        }
    }
}
