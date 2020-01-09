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
        createOrder()
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
    
        func createOrder() {
                order = Order()
                order!.licensePlateNumber = LICENSE_PLATE_NUMBER
                order!.date = Date()
            // TODO: set order number after receiving data
//                order!.number = latestOrder.number + 1
        }
    
    
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
            
            if(!selectedItem.checked) { // if not checked, then check and add to order
                selectedItem.checked = true
                order!.items.append(selectedItem)
//                selectedItem.order = order
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
