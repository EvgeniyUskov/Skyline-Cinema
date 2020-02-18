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
    let networkManager = NetworkManager()
    
    func resetUI() {
        self.headerLabel.isHidden = false
        self.orderIsPreparingLabel.isHidden = false
        self.bonApetitLabel.text = Constants.bonApetit
    }
    
    func setUIToErrorMode() {
        self.headerLabel.isHidden = true
        self.orderIsPreparingLabel.isHidden = true
        self.bonApetitLabel.text = Constants.bonApetitError
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetUI()
        if let orderLocal = order {
            let orderRequest = OrderRequest(order: orderLocal)
            let parameters = orderRequest.transformToParameters()
            if Constants.networkActive {
                Alamofire.request(networkManager.skylineCinemaOrderRequestURL,
                                  method: .post,
                    parameters: parameters,
                    encoding: JSONEncoding.default).responseJSON { response in
                        debugPrint(response)
                        if !response.result.isSuccess {
                            self.setUIToErrorMode()
                        }
                }
            }
        }
    }
}
