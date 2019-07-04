//
//  PopcornViewController.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 03/07/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import UIKit

class PopcornViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var popcornTableView: UITableView!
    let itemConstants = ItemConstants()
    let popcornList: [Item] = itemConstants.getPopcornList()
    
    var order = Order()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popcornTableView.delegate = self
        popcornTableView.dataSource = self
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(itemTapped))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PopcornViewController.tapEdit))
        popcornTableView.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        
        popcornTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
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
        cell.itemId = popcornList[indexPath.row].id
        
        return cell
    }
    
    //Resize row
    func configureTableView () {
        popcornTableView.estimatedRowHeight = 250
        popcornTableView.rowHeight = UITableView.automaticDimension
    }
    
    // TAP Recognizer
    @objc func tapEdit(recognizer: UITapGestureRecognizer)  {
        if recognizer.state == UIGestureRecognizer.State.ended {
            let tapLocation = recognizer.location(in: popcornTableView)
            if let tapIndexPath = popcornTableView.indexPathForRow(at: tapLocation) {
                if let tappedCell = popcornTableView.cellForRow(at: tapIndexPath) as? CustomCell {
                    // add an item to order
                    order.addItem(itemConstants.getItemById(id: tappedCell.itemId))
                }
            }
        }
    }
}
