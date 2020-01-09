//
//  CartTableViewController.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 12.12.2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import UIKit
import RealmSwift

class CartTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var cartTableView: UITableView!
    
    private let realm = try! Realm()
    
    private var itemList = [Item]()
            var order: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        
    cartTableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        if let orderLocal = order {
            itemList = Array(orderLocal.items)
        }
        
    cartTableView.reloadData()
    resizeTableViewRows()
    cartTableView.separatorStyle = .none
    }
    
    // Resize row
    func resizeTableViewRows () {
        cartTableView.rowHeight = 150
    }
    
    
       // MARK: - TableView Implementation methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return itemList.count
       }
       // show data on table row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = cartTableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
           
           let item = itemList[indexPath.row]
        cell.itemImageView.image = UIImage(named: "popcorn")
               cell.accessoryType = item.checked == true ? .checkmark :  .none
           return cell
       }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // add item to order
            let selectedItem = itemList[indexPath.row]
            try! realm.write {
                selectedItem.checked = !selectedItem.checked
                if(selectedItem.checked) { // if checked, then add to order
                    order!.items.append(selectedItem)
                    selectedItem.order = order
                } else {
                    cartTableView.deselectRow(at: indexPath, animated: true)
                }
            }

    //
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
}
