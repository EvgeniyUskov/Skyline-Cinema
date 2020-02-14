//
//  PopcornViewController.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 03/07/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import SVProgressHUD

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var goToOrderButton: UIButton!
    @IBOutlet weak var popcornTableView: UITableView!
    let realm = try! Realm()
    
    private var menuList: [Item] = [Item]()
    
    private var order: Order?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        SVProgressHUD.show()
        let networkAdapter = NetworkManager()
        networkAdapter.getItems()
        
        disableButon()
        
        popcornTableView.delegate = self
        popcornTableView.dataSource = self
        popcornTableView.allowsMultipleSelection = true
        popcornTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        loadData()
        
        popcornTableView.reloadData()
        resizeTableViewRows()
//        popcornTableView.separatorStyle = .none
    }

    func disableButon() {
        goToOrderButton.isEnabled = false
        goToOrderButton.backgroundColor = UIColor.flatBlackColorDark()
        goToOrderButton.setTitleColor(UIColor.flatGrayColorDark(), for: .disabled)
    }
    
    func enableButton(){
        goToOrderButton.isEnabled = true
        goToOrderButton.backgroundColor = UIColor.flatWatermelon()
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
            order!.licensePlateNumber = UserDefaults.standard.string(forKey: Constants.propLicensePlateNumber)!
                order!.date = Date()
        }
    
    
    // MARK: - TableView Implementation methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    // show data on table row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = popcornTableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        let item = menuList[indexPath.row]
        cell.itemLabel.text = item.title
        cell.priceLabel.text = String("\(Int(item.price)) руб")
        cell.descriptionLabel.text = item.descript
        cell.itemImageView.image = UIImage(named: "popcorn")
        cell.accessoryType = item.checked == true ? .checkmark :  .none
        cell.setup()
        return cell
    }
    
    // Resize row
    func resizeTableViewRows () {
        popcornTableView.rowHeight = 280//UITableView.automaticDimension
    }
    
    //UITableViewCell click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: delete when deselect
        let selectedItem = menuList[indexPath.row]
        try! realm.write {
            if(!selectedItem.checked) {
                selectedItem.checked = true
                order!.items.append(selectedItem)
            } else {
                selectedItem.checked = false
                popcornTableView.deselectRow(at: indexPath, animated: true)
                removeItemFromOrder(item: selectedItem)
            }
        }
        
        if order!.items.count != 0 {
            enableButton()
        } else {
            disableButon()
        }
        
        popcornTableView.reloadData()
        saveData()
    }
    
    func removeItemFromOrder(item: Item) {
        var index: Int = 0
        for itemLocal in order!.items {
            if itemLocal.id == item.id {
                continue
            } else {
                index += 1
            }
        }
        order!.items.remove(at: index)
    }
    
    //passing data between view controlers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCart" {
            let cartController = segue.destination as! CartTableViewController
            cartController.order = order
        }
    }
    
    @IBAction func goToOrderButtonTapped(_ sender: UIButton) {
        
    }
    
    
}
