//
//  TimeTableViewCell.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 14.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import UIKit

class TimeTableViewCell: UITableViewCell {

    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
        
    func setUp(viewModel: TimeTableCellViewModel) {
        self.titleLabel.text = viewModel.title
        self.dateLabel.text = viewModel.date
        self.rateLabel.text = viewModel.rateKp
        self.movieImageView.image = UIImage(named: "popcorn")
        self.accessoryType = .detailButton
    }
    
    
}
