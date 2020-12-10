//
//  PopcornViewController.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 03/07/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import UIKit
import SVProgressHUD

class MenuViewController: UIViewController {
    
    @IBOutlet weak var goToOrderButton: UIButton!
    @IBOutlet weak var popcornTableView: UITableView!
    
    private var viewModel: MenuViewModelProtocol?
    private var order: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        NetworkManager.shared.getItems(completion: {
            [unowned self]
            categories in
            viewModel = MenuViewModel(categories: categories)
            SVProgressHUD.dismiss()
        })
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
        goToOrderButton.backgroundColor = UIColor.black
        goToOrderButton.setTitleColor(UIColor.gray, for: .disabled)
    }
    
    func enableGoToOrderButon(){
        goToOrderButton.isEnabled = true
        goToOrderButton.backgroundColor = UIColor.systemPink
    }
    
    
}

// MARK: - TableView Implementation methods
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = viewModel else {return 0}
        return viewModel.categoriesViewModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {return 0}
        return viewModel.categoriesViewModel[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let viewModel = viewModel else {return ""}
        return viewModel.categoriesViewModel[section].name
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
        groupLabel.textColor = UIColor.white
        groupLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        let headerView = UIView()
        headerView.layer.cornerRadius = CGFloat(10.0)
        headerView.addSubview(groupLabel)
        
        return headerView
    }
    
    // show data on table row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = popcornTableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        guard let viewModel = viewModel else {return UITableViewCell()}
        let item = viewModel.categoriesViewModel[indexPath.section].items[indexPath.row]
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
        guard let viewModel = viewModel else {return}
        // TODO: delete when deselect
        var selectedItemViewModel = viewModel.categoriesViewModel[indexPath.section].items[indexPath.row]
        let item = viewModel.getItem(forIndexPath: indexPath)
        
        if(!selectedItemViewModel.checked) {
            selectedItemViewModel.checked = true
            order!.items.append(item)
        } else {
            selectedItemViewModel.checked = false
            popcornTableView.deselectRow(at: indexPath, animated: true)
            removeItemFromOrder(item: item)
        }
        
        if order!.items.count != 0 {
            enableGoToOrderButon()
        } else {
            disableGoToOrderButon()
        }
        
        popcornTableView.reloadData()
    }
}
