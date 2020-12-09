//
//  InfoViewController.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 19.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class InfoViewController: UIViewController {
    
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var safButton: UIButton!
    @IBOutlet weak var vkButton: UIButton!
    @IBOutlet weak var igButton: UIButton!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var tlgButton: UIButton!
    
    
    @IBOutlet weak var phoneCaptionLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var addressTableView: UITableView!
    
    
    var addressList = [Address]()
    var selectedAddress: Address?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        cityNameLabel.text = UserDefaults.standard.value(forKey: Constants.propCity) as! String
        callButton.titleLabel?.font = getFreeFont()
        callButton.setTitle("\u{f879}", for: .normal)
        vkButton.titleLabel?.font = getBrandsFont()
        vkButton.setTitle("\u{f189}", for: .normal)
        igButton.titleLabel?.font = getBrandsFont()
        igButton.setTitle("\u{f16d}", for: .normal)
        fbButton.titleLabel?.font = getBrandsFont()
        fbButton.setTitle("\u{f39e}", for: .normal)
        tlgButton.titleLabel?.font = getBrandsFont()
        tlgButton.setTitle("\u{f3fe}", for: .normal)
        safButton.titleLabel?.font = getBrandsFont()
        safButton.setTitle("\u{f267}", for: .normal)
        
        addressTableView.dataSource = self
        addressTableView.delegate = self
        //        phoneLabel.isHidden = true
        //        phoneCaptionLabel.isHidden = true
        addressList = NetworkManager.shared.getAddresses()
        addressTableView.separatorStyle = .none
        addressTableView.reloadData()
        addressTableView.allowsMultipleSelection = false
    }
    
    func getFreeFont() -> UIFont {
        return UIFont(name: "Font Awesome 5 Free", size: 30)!
    }
    
    func getBrandsFont() -> UIFont {
        return UIFont(name: "Font Awesome 5 Brands", size: 30)!
    }
    
    func cellSetUp(cell: UITableViewCell, indexPath: IndexPath) -> UITableViewCell {
        let address = addressList[indexPath.row]
        cell.textLabel!.text = address.address
        cell.detailTextLabel!.text = address.description
        return cell
    }
    
    @IBAction func callButtonTapped(_ sender: Any) {
        if let address = selectedAddress {
            UIApplication.shared.openURL(NSURL(string: "tel://\(address.phoneNumber)") as! URL)
        }
    }
    @IBAction func vkButtonTapped(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: Routes.vkURL) as! URL)
    }
    @IBAction func igButtonTapped(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: Routes.igURL) as! URL)
    }
    @IBAction func fbButtonTapped(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: Routes.fbURL) as! URL)
    }
    @IBAction func tlgButtonTapped(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: Routes.tlgURL) as! URL)
    }
    @IBAction func safButtonTapped(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: Routes.safariURL) as! URL)
    }
    
}

extension InfoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAddress = addressList[indexPath.row]
        
        if let address = selectedAddress {
            callButton.setTitle("\u{f879} \(address.phoneNumber)", for: .normal)
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath)
        return cellSetUp(cell: cell, indexPath: indexPath)
    }
    
}
