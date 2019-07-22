//
//  PopcornViewController.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 03/07/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import UIKit
import CoreData

class PopcornViewController: UIViewController, UITableViewDelegate, UITableViewDataSource//, UIGestureRecognizerDelegate {
{
    @IBOutlet weak var goToOrderButton: UIButton!
    
    @IBOutlet weak var popcornTableView: UITableView!
    //MARK: Constants
    let TITLE = "Попкорн"
    
    let SEARCH_POPCORN_QUERY = "title CONTAINS[cd] %@"
    let SEARCH_ORDER_QUERY = "date == max(date) && state = %@"
    
    //MARK: Order States
    let INITIALIZED = "INITIALIZED"
    let ORDERED = "ORDERED"
    let OCMPLETED = "COMPLETED"
    let REFUSED = "REFUSED"
    //MARK: Fields
    let context = (UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
    
    var popcornList = [TableViewItemWrapper]()
    var order: Order!
    
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
    
    // MARK: - TableView Implementation methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popcornList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = popcornTableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        let wrappedItem = popcornList[indexPath.row]
        cell.itemLabel.text = wrappedItem.item.descript
        cell.itemImageView.image = UIImage(named: "popcorn")
        cell.accessoryType = wrappedItem.checked == true ? .checkmark :  .none

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
        let selectedItem = popcornList[indexPath.row]
        selectedItem.checked = !selectedItem.checked
        print(selectedItem)
        order!.items!.adding(selectedItem.item!)
        if order.items?.count != 0 {
            goToOrderButton.isHidden = false
        }
        popcornTableView.deselectRow(at: indexPath, animated: true)
        popcornTableView.reloadData()
        saveData()
    }
    
    //MARK: Data manipulation methods
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil ) {
        //ITEMS
        let itemPredicate = NSPredicate(format:  SEARCH_POPCORN_QUERY, TITLE)
        request.predicate = itemPredicate
        do{
            popcornList = convertItemListToWrappedList(list: try context.fetch(request))
//            mockItems()
        } catch {
            print("error fetching data from context\(error)")
        }
        
        //ORDER
        let orderRequest: NSFetchRequest<Order> = Order.fetchRequest()
        orderRequest.fetchLimit = 1
        let orderPredicate = NSPredicate(format: SEARCH_ORDER_QUERY)
        orderRequest.predicate = orderPredicate
        do {
            order = try self.context.fetch(orderRequest ).first
        } catch {
            print("error fetching data from context\(error)")
        }
        if(order == nil) {
            order = Order(context: context)
            order.orderNumber = 1
            order.state = INITIALIZED
            order.licensePlateNumber = "B522YO_154RUS"
            order.date = Date()
        }
    }
    
    func saveData() {
        do{
            try context.save()
        } catch {
            print("error saving context\(error)")
        }
    }

    //MARK: Conversion methods
    func convertItemListToWrappedList(list: [Item]) -> [TableViewItemWrapper]{
        var wrappedList = [TableViewItemWrapper]()
        for item in list {
            let wrapper = TableViewItemWrapper()
            wrapper.item = item
            wrappedList.append(wrapper)
        }
        return wrappedList
    }
    
    func convertWrappedListToItemList(list: [TableViewItemWrapper]) -> [Item]{
        var itemList = [Item]()
        for wrapper in list {
            itemList.append(wrapper.item)
        }
        return itemList
    }
    
    @IBAction func goToOrderButtonTapped(_ sender: UIButton) {
    }
    // MARK: Mock items methods
    func mockItems() {
        var itemList = [Item]()
        
        let popcnItem = Item(context: context)
        popcnItem.title = "попкорн"
        popcnItem.descript = "Большой сладкий"
        popcnItem.price = 300.0
        let popcnItem2 = Item(context: context)
        popcnItem2.title = "попкорн"
        popcnItem2.descript = "Средний сладкий"
        popcnItem2.price = 300.0
        let popcnItem3 = Item(context: context)
        popcnItem3.title = "попкорн"
        popcnItem3.descript = "Маленький сладкий"
        popcnItem3.price = 300.0
        
        let popcnItem4 = Item(context: context)
        popcnItem4.title = "попкорн"
        popcnItem4.descript = "Большой соленый"
        popcnItem4.price = 300.0
        let popcnItem5 = Item(context: context)
        popcnItem5.title = "попкорн"
        popcnItem5.descript = "Средний соленый"
        popcnItem5.price = 300.0
        let popcnItem6 = Item(context: context)
        popcnItem6.title = "попкорн"
        popcnItem6.descript = "Маленький соленый"
        popcnItem6.price = 300.0
        
        itemList.append(popcnItem)
        itemList.append(popcnItem2)
        itemList.append(popcnItem3)
        itemList.append(popcnItem4)
        itemList.append(popcnItem5)
        itemList.append(popcnItem6)
        
        popcornList = convertItemListToWrappedList(list: itemList)
    }
    
}
