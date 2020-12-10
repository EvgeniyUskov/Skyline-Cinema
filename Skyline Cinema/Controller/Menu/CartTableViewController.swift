//
//  CartTableViewController.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 12.12.2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import UIKit
import RealmSwift
import SVProgressHUD
//import YooKassaPayments
//import YooKassaPaymentsApi

class CartTableViewController: UIViewController {
    
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    private let realm = try! Realm()
    private var itemViewModelList = [CartCellViewModel]()
    var order: Order?
    var totalAmount: Double = 0
    var payment: Payment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        
        cartTableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        if let orderLocal = order {
            let itemListLocal = Array(orderLocal.items)
            for item in itemListLocal {
                let cartItem = CartCellViewModel(item: item)
                itemViewModelList.append(cartItem)
            }
        }
        cartTableView.backgroundView = UIImageView(image: UIImage(named: "background"));
        
        cartTableView.reloadData()
        cartTableView.rowHeight = 250
        cartTableView.separatorStyle = .none
        totalAmount = initTotalAmount()
        totalAmountLabel.text = Constants.totalAmount + String(totalAmount)
    }
    
    @IBAction func paymentButtonTapped(_ sender: Any) {
        SVProgressHUD.show()
        // TODO: delete this
//        let apiKey = defaults.string(forKey: Constants.propYandexApiKey)!
//        let apiKey = Constants.mobileSDKApiKey
//        let shopId = Constants.shopId
        
//        let amount = Amount(value: Decimal(totalAmount), currency: .rub)
//        if let order = order {
//            var orderItems: String
//            for item in order.items{
//                orderItems += item.title + ", "
//            }
//            let tokenizationModuleInputData = TokenizationModuleInputData(
//                clientApplicationKey: apiKey,
//                shopName: Constants.shopName ,
//                purchaseDescription: "Номер Авто: \(order.licensePlateNumber): Заказ еды.", // \(orderItems)
//                amount: amount, savePaymentMethod: .on)
//
//            let inputData: TokenizationFlow = .tokenization(tokenizationModuleInputData)
            
//            let viewController = TokenizationAssembly.makeModule(inputData: inputData, moduleOutput: self)
//            present(viewController, animated: true, completion: nil)
//        }
    }
    
//    func createPayment (paymentToken: Tokens, amount: Amount, description: String) {
//        NetworkManager.shared.createPayment(paymentToken: paymentToken,
//                                     amount: amount,
//                                     description: description,
//                                     completion: {
//            [weak self] payment in
//                self?.payment = payment
//                DispatchQueue.main.async {
////                    self?.computerTableView.reloadData()
//            }})
//    }
    
    func calculateTotalAmount() -> Double {
        var total: Double = 0
        for item in itemViewModelList {
            let amount = item.priceDouble * Double(item.count)
            total += amount
        }
        return total
    }
    
    func initTotalAmount() -> Double {
        var total: Double = 0
        for item in itemViewModelList {
            total += item.priceDouble
        }
        return total
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPayment" {
            
            //            let buyOrderViewController = segue.destination as! BuyOrderViewController
            //            buyOrderViewController.order = order
            //            buyOrderViewController.totalAmount = totalAmount
        }
    }
}

// MARK: - TableView Implementation methods
extension CartTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemViewModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
        cell.delegate = self
        //        cell.itemImageView.image = UIImage(named: "popcorn")
        cell.setUp(viewModel: itemViewModelList[indexPath.row], indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // add item to order
        try! realm.write {
        }
        
        cartTableView.reloadData()
    }
}

// MARK: - CellStepperDelegate Methods
extension CartTableViewController: CellStepperDelegate {
    
    func didChangeValue(stepperValue: Int, indexPath: IndexPath) {
        itemViewModelList[indexPath.row].count = stepperValue
        totalAmount = calculateTotalAmount()
        totalAmountLabel.text = Constants.totalAmount + String(totalAmount)
    }
}
// MARK: - TokenizationModuleOutput
/*extension CartTableViewController: TokenizationModuleOutput {
      func tokenizationModule(_ module: TokenizationModuleInput,
                              didTokenize token: Tokens,
                              paymentMethodType: PaymentMethodType) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        // TODO: узнать что это значит
        // Отправьте токен в вашу систему
        // Передайте токен на ваш сервер.
        if let order = order {
            let description = "Номер Авто: \(order.licensePlateNumber): Заказ еды." // \(orderItems)
            let amount = Amount(value: Decimal(totalAmount), currency: .rub)
            
            createPayment(paymentToken: token, amount: amount, description: description)
        }
        
      }

      func didFinish(on module: TokenizationModuleInput,
                     with error: YandexCheckoutPaymentsError?) {
          DispatchQueue.main.async { [weak self] in
              guard let self = self else { return }
              self.dismiss(animated: true)
          }
      }
    func didSuccessfullyPassedCardSec(on module: TokenizationModuleInput) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            // Now close tokenization module
            self.dismiss(animated: true)
        }
    }
}*/

