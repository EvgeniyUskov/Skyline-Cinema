//
//  CartTableViewCell.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 12.12.2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemCountStepper: UIStepper!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
