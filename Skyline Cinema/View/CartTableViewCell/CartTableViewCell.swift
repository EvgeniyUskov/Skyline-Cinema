//
//  CartTableViewCell.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 12.12.2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemCountStepper: UIStepper!
    var indexPath: IndexPath!
    weak var delegate: CellStepperDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemCountStepper.minimumValue = 0
        itemCountStepper.maximumValue = 8
        itemCountStepper.stepValue = 1
        itemCountStepper.value = 1
        itemCountStepper.setDecrementImage(itemCountStepper.decrementImage(for: .normal), for: .normal)
        itemCountStepper.setIncrementImage(itemCountStepper.incrementImage(for: .normal), for: .normal)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func stepperTapped(_ sender: UIStepper) {
        countLabel.text = String(Int(sender.value))
        delegate?.didChangeValue(stepperValue: Int(sender.value), indexPath: indexPath)
    }
    
    func setUp (viewModel: CartCellViewModel, indexPath: IndexPath) {
        // TODO: Image loading
        self.backgroundView =  UIImageView(image: UIImage(named: "background"))
        self.contentView.layer.cornerRadius = CGFloat(10.0)
        self.indexPath = indexPath
        self.itemImageView.image = UIImage(named: "popcorn")
        self.countLabel.text = String(viewModel.count)
        self.titleLabel.text = viewModel.title
        self.priceLabel.text = String("\(viewModel.priceString) руб")
    }
}
