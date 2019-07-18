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
    
    @IBOutlet weak var popcornTableView: UITableView!
    //MARK: Constants
    let TITLE = "Попкорн"
    let SEARCH_POPCORN_QUERY = "title CONTAINS[cd] %@"
    let SEARCH_ORDER_QUERY = "date.@max && state = %@"
    //MARK: Order States
    let INITIALIZED = "INITIALIZED"
    let ORDERED = "ORDERED"
    let OCMPLETED = "COMPLETED"
    //MARK: Fields
    let context = (UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
    
    var popcornList = [Item]()
    var order: Order!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popcornTableView.delegate = self
        popcornTableView.dataSource = self
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PopcornViewController.tapEdit))
//        popcornTableView.addGestureRecognizer(tapGesture)
//        tapGesture.delegate = self
//
        popcornTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")

        loadData()
        
        configureTableView()
    }
    
    // MARK: - TableView Implementation methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popcornList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = popcornTableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
//        cell.itemImageView.image =
        cell.itemLabel.text = popcornList[indexPath.row].description
//        cell.itemId = popcornList[indexPath.row].id
        
        return cell
    }
    
    // Resize row
    func configureTableView () {
        popcornTableView.estimatedRowHeight = 250
        popcornTableView.rowHeight = UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = popcornList[indexPath.row]
        order!.items?.adding(selectedItem)
    }
    // TAP Recognizer
//    @objc func tapEdit(recognizer: UITapGestureRecognizer)  {
//        if recognizer.state == UIGestureRecognizer.State.ended {
//            let tapLocation = recognizer.location(in: popcornTableView)
//            if let tapIndexPath = popcornTableView.indexPathForRow(at: tapLocation) {
//                //if let tappedCell = popcornTableView.cellForRow(at: tapIndexPath) as? CustomCell {
//                    // add an item to order
////                    order.addItem(itemConstants.getItemById(id: tappedCell.itemId))
//                //}
//                let indexPath = popcornTableView.indexPathForSelectedRow
//            }
//        }
//    }
    
    //MARK: Data manipulation methods
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil ) {
        let itemPredicate = NSPredicate(format:  SEARCH_POPCORN_QUERY, TITLE)
        request.predicate = itemPredicate
        
        do{
            popcornList = try context.fetch(request)
        } catch {
            print("error fetching data from context\(error)")
        }
        
        let orderRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
        let orderPredicate = NSPredicate(format:  SEARCH_ORDER_QUERY, "INITIALIZED")
        request.predicate = orderPredicate
        do{
            order = try context.fetch(orderRequest)[0] as! Order
        } catch {
            print("error fetching data from context\(error)")
        }
        if(order == nil) {
            order = Order(context: context)
            order.state = INITIALIZED
        }
    }
    
    func saveData() {
        do{
            try context.save()
        } catch {
            print("error saving context\(error)")
        }
    }

    
}
