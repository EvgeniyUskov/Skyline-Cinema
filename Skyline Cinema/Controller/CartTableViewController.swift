//
//  CartTableViewController.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 12.12.2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import UIKit
import RealmSwift

class CartTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CellStepperDelegate {
    
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    private let realm = try! Realm()
    private var itemViewModelList = [CartCellViewModel]()
    var order: Order?
    var totalAmount: Double = 0
    
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
        resizeTableViewRows()
        cartTableView.separatorStyle = .none
        totalAmount = initTotalAmount()
        totalAmountLabel.text = Constants.totalAmount + String(totalAmount)
    }
    
    // Resize row
    func resizeTableViewRows () {
        cartTableView.rowHeight = 250
    }
    
    
    // MARK: - TableView Implementation methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemViewModelList.count
    }
    
    // show data on table row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
        cell.delegate = self
//        cell.itemImageView.image = UIImage(named: "popcorn")
        cell.setUp(viewModel: itemViewModelList[indexPath.row], indexPath: indexPath)
        return cell
    }
    
    // click on row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // add item to order
        try! realm.write {
        }
        
        cartTableView.reloadData()
        saveData()
    }
    
    func saveData() {
        do{
            try realm.write {
                realm.add(order!)
            }
        } catch {
            print("error saving realm order\(error)")
        }
    }
    
    // MARK: CellStepperDelegateMethod
    func didChangeValue(stepperValue: Int, indexPath: IndexPath) {
        itemViewModelList[indexPath.row].count = stepperValue
        totalAmount = calculateTotalAmount()
        totalAmountLabel.text = Constants.totalAmount + String(totalAmount)
    }
    
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
            let buyOrderViewController = segue.destination as! BuyOrderViewController
            buyOrderViewController.order = order
        }
    }
}
