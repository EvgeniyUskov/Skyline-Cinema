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
    
    func setup() {
//        self.itemImageView.layer.cornerRadius = CGFloat(10.0)
        self.contentView.layer.cornerRadius = CGFloat(10.0)
        self.backgroundView =  UIImageView(image: UIImage(named: "background"))
        
    }
    
}
