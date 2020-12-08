//
//  PopcornViewController.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 03/07/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import UIKit
//import RealmSwift
import SVProgressHUD

class MenuViewController: UIViewController {
    
    @IBOutlet weak var goToOrderButton: UIButton!
    @IBOutlet weak var popcornTableView: UITableView!
//    let realm = try! Realm()
    
    private var menuList: [Item] = [Item]()
    private var menuListCategories: [Category] = [Category]()
    private var order: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        menuListCategories = NetworkManager.shared.getItems()
        sortCategories()
        disableGoToOrderButon()
        setUpTableView()
        createOrder()
    }
    
    func setUpTableView() {
        popcornTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        self.popcornTableView.backgroundView = UIImageView(image: UIImage(named: "background"));
        
        popcornTableView.delegate = self
        popcornTableView.dataSource = self
        popcornTableView.allowsMultipleSelection = true
        popcornTableView.reloadData()
        popcornTableView.rowHeight = 280
        popcornTableView.separatorStyle = .none
        
    }
    
    //MARK: -Data manipulation methods
//    func loadData() {
//        menuList = Array(realm.objects(Item.self))
//        createOrder()
//    }
//
//    func saveData() {
//        do{
//            try realm.write {
//                realm.add(order!)
//            }
//        } catch {
//            print("error saving realm order\(error)")
//        }
//    }
    
    func createOrder() {
        order = Order()
        order!.licensePlateNumber = UserDefaults.standard.string(forKey: Constants.propLicensePlateNumber)!
        order!.date = Date()
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
    
    func sortCategories() {
        menuListCategories = menuListCategories.sorted(by: { (category1, category2) -> Bool in
            return Constants.menuMap[category1.name]! < Constants.menuMap[category2.name]!
        })
    }
}

// MARK: - TableView Implementation methods
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuListCategories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuListCategories[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return menuListCategories[section].name
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let groupLabel = UILabel()
        if section == 0 {
            groupLabel.frame = CGRect(x: 10, y: 15, width: 200, height: 20)
        }
        else {
            groupLabel.frame = CGRect(x: 10, y: 0, width: 200, height: 20)
        }
        groupLabel.font = UIFont.systemFont(ofSize: 22)
        groupLabel.textColor = FlatWhite()
        groupLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        let headerView = UIView()
        headerView.layer.cornerRadius = CGFloat(10.0)
        headerView.addSubview(groupLabel)
        
        return headerView
    }
    
    // show data on table row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = popcornTableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        let item = menuListCategories[indexPath.section].items[indexPath.row]
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
        let selectedItem = menuListCategories[indexPath.section].items[indexPath.row]
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
}
