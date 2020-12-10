//
//  CustomCell.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 19/07/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(item: ItemViewModelProtocol) {
        self.contentView.layer.cornerRadius = CGFloat(10.0)
        self.backgroundView =  UIImageView(image: UIImage(named: "background"))
        
        itemLabel.text = item.title
        priceLabel.text = String("\(item.price) руб")
        descriptionLabel.text = item.descript
        itemImageView.image = UIImage(named: "popcorn")
        accessoryType = item.checked == true ? .checkmark :  .none
        
    }
    
}
