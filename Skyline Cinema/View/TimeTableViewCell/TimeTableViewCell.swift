//
//  TimeTableViewCell.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 14.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import UIKit
import Alamofire

class TimeTableViewCell: UITableViewCell {

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
        self.dateLabel.text = viewModel.time
        self.movieImageView.image = UIImage(named: "movieBackground")
        self.movieImageView.layer.cornerRadius = CGFloat(10.0)
//        getMoviePosterURL(kinopoiskId: viewModel.kinopoiskId)
//        self.accessoryType = .detailButton
    }
    
//    func getMoviePosterURL(kinopoiskId: String) {
//        let kinopoiskParser = KinopoiskHTMLParser()
//        var imageURL = ""
//        Alamofire.request(NetworkManager.shared.getKinopoiskMovieDetailsURL(kinopoiskMovieId: kinopoiskId), method: .get).responseString { (response) in
//            if response.result.isSuccess {
//                print("MOVIE DETAILS KINOPISK SUCCESS: \(response)" )
//                imageURL = kinopoiskParser.getImageURL(response: response)
//            }
//
//            DispatchQueue.main.async { [weak self] in
//                self?.movieImageView.sd_setImage(with: URL(string: imageURL ), completed: nil)
//            }
//        }
//    }
    
    
}
