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
    private var menuListCategories: [String: [Item]] = [String: [Item]]()
    private var order: Order?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        SVProgressHUD.show()
        let networkManager = NetworkManager()
        menuListCategories = networkManager.getItems()
        
        disableGoToOrderButon()
        
        popcornTableView.delegate = self
        popcornTableView.dataSource = self
        popcornTableView.allowsMultipleSelection = true
        popcornTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
//        self.popcornTableView.backgroundView = UIImageView(image: UIImage(named: "background"));
        let backView = UIView()
        backView.backgroundColor = .red
        popcornTableView.backgroundView = backView
        loadData()
        
        popcornTableView.reloadData()
        popcornTableView.rowHeight = 280//UITableView.automaticDimension
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
        order!.licensePlateNumber = UserDefaults.standard.string(forKey: Constants.propLicensePlateNumber)!
        order!.date = Date()
    }
    
    
    // MARK: - TableView Implementation methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuListCategories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(menuListCategories)[section].value.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(menuListCategories)[section].key
    }
    // show data on table row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = popcornTableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        let item = Array(menuListCategories)[indexPath.section].value[indexPath.row]
        cell.itemLabel.text = item.title
        cell.priceLabel.text = String("\(Int(item.price)) руб")
        cell.descriptionLabel.text = item.descript
        cell.itemImageView.image = UIImage(named: "popcorn")
        cell.accessoryType = item.checked == true ? .checkmark :  .none
        cell.setup()
        return cell
    }
    
    //UITableViewCell click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: delete when deselect
        let selectedItem = Array(menuListCategories)[indexPath.section].value[indexPath.row]
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
            enableGoToOrderButon()
        } else {
            disableGoToOrderButon()
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
 
    func disableGoToOrderButon() {
        goToOrderButton.isEnabled = false
        goToOrderButton.backgroundColor = UIColor.flatBlackColorDark()
        goToOrderButton.setTitleColor(UIColor.flatGrayColorDark(), for: .disabled)
    }
    
    func enableGoToOrderButon(){
        goToOrderButton.isEnabled = true
        goToOrderButton.backgroundColor = UIColor.flatWatermelon()
    }
    
}
