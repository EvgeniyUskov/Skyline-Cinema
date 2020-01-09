//
//  PopcornViewController.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 03/07/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import UIKit
import RealmSwift

class PopcornViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let TITLE = "Меню"
    
    @IBOutlet weak var goToOrderButton: UIButton!
    @IBOutlet weak var popcornTableView: UITableView!
    let realm = try! Realm()
    
    //MARK: Utils
    let dateUtils = DateUtils()
    //MARK: Constants
    
    private let ORDER_STATUS_INITIALIZED = "INITIALIZED"
    private let LICENSE_PLATE_NUMBER = "LICENSE_PLATE_NUMBER"
    private let SEARCH_ORDER_QUERY = "state = %@ and date = %@"
    
    //MARK: Fields
    private var menuList: [Item] = [Item]()
    
    private var order: Order?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        goToOrderButton.isHidden = true
        
        popcornTableView.delegate = self
        popcornTableView.dataSource = self
        popcornTableView.allowsMultipleSelection = true
        popcornTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        loadData()
        
        popcornTableView.reloadData()
        resizeTableViewRows()
        popcornTableView.separatorStyle = .none
    }
    
    
    //MARK: Data manipulation methods
    func loadData() {
        menuList = loadItems()
    }
    // TODO: refactor method merge loadItems() with loadData()
    func loadItems() -> [Item] {
        return Array(realm.objects(Item.self))
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
    
    //    func loadOrCreateOrder() {
    //        // Get latest order with state "initialized"
    //        if let latestInitializedOrder = realm.objects(Order.self).filter(SEARCH_ORDER_QUERY, ORDER_STATUS_INITIALIZED, dateUtils.startOfTheDay()).first {
    //            // if it is, use it
    //            order = latestInitializedOrder
    //        } else {
    //            // if no orders, create new one
    //            order = Order()
    //            order!.state = ORDER_STATUS_INITIALIZED
    //            order!.licensePlateNumber = LICENSE_PLATE_NUMBER
    //            order!.date = Date()
    //            // if it's not a first order
    //            // TODO: check the query
    //            if let latestOrder = realm.objects(Order.self).sorted(byKeyPath: "date", ascending: true).first {
    //                order!.number = latestOrder.number + 1
    //            }
    //            // if it's a first order
    //            else {
    //                order!.number = 1
    //            }
    //
    //        }
    //    }
    
    //    func createItems() -> [Item] {
    //        var popcnItemArray: [Item] = [Item]()
    //
    //        let popcnItem = Item()
    //            popcnItem.title = "попкорн"
    //            popcnItem.descript = "Большой сладкий"
    //            popcnItem.price = 300.0
    //        let popcnItem2 = Item()
    //            popcnItem2.title = "попкорн"
    //            popcnItem2.descript = "Средний сладкий"
    //            popcnItem2.price = 300.0
    //        let popcnItem3 = Item()
    //            popcnItem3.title = "попкорн"
    //            popcnItem3.descript = "Маленький сладкий"
    //            popcnItem3.price = 300.0
    //        let popcnItem4 = Item()
    //            popcnItem4.title = "попкорн"
    //            popcnItem4.descript = "Большой соленый"
    //            popcnItem4.price = 300.0
    //        let popcnItem5 = Item()
    //            popcnItem5.title = "попкорн"
    //            popcnItem5.descript = "Средний соленый"
    //            popcnItem5.price = 300.0
    //        let popcnItem6 = Item()
    //            popcnItem6.title = "попкорн"
    //            popcnItem6.descript = "Маленький соленый"
    //            popcnItem6.price = 300.0
    //
    //          popcnItemArray.append(popcnItem)
    //          popcnItemArray.append(popcnItem2)
    //          popcnItemArray.append(popcnItem3)
    //          popcnItemArray.append(popcnItem4)
    //          popcnItemArray.append(popcnItem5)
    //          popcnItemArray.append(popcnItem6)
    //        return popcnItemArray
    //    }
    
    
    // MARK: - TableView Implementation methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    // show data on table row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = popcornTableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        let item = menuList[indexPath.row]
        cell.itemLabel.text = item.descript
        cell.itemImageView.image = UIImage(named: "popcorn")
        cell.accessoryType = item.checked == true ? .checkmark :  .none
        return cell
    }
    
    // Resize row
    func resizeTableViewRows () {
        //        popcornTableView.estimatedRowHeight = 150
        popcornTableView.rowHeight = 150//UITableView.automaticDimension
    }
    
    //UITableViewCell click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // add item to order
        let selectedItem = menuList[indexPath.row]
        try! realm.write {
            //            selectedItem.checked = !selectedItem.checked
            selectedItem.checked = true
            if(selectedItem.checked) { // if checked, then add to order
                order!.items.append(selectedItem)
                selectedItem.order = order
            } else {
                popcornTableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        if order!.items.count != 0 {
            goToOrderButton.isHidden = false
        }
        
        popcornTableView.reloadData()
        saveData()
    }
    
    //passing data between view controlers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCart" {
            //            if let indexPath = popcornTableView.indexPathForSelectedRow {
            let cartController = segue.destination as! CartTableViewController
            cartController.order = order
            //                cartController.delegate = self
            //            }
        }
    }
    
    @IBAction func goToOrderButtonTapped(_ sender: UIButton) {
        
    }
    
    
}
