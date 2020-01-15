//
//  MovieInfoViewController.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 14.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    let networkManager = NetworkManager()
    var movie : TimeTableCellViewModel?
    
    @IBOutlet weak var rateKpLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movieLocal = self.movie {
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                let rates = self?.networkManager.getMovieRates(kinopoiskId: movieLocal.kinopoiskId)
                movieLocal.setRates(rates: rates!)
            }
            
            self.setUp(movie: movieLocal)
        }
    }
    
    func setUp(movie: TimeTableCellViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.rateKpLabel.text = movie.rateKp
            self?.titleLabel.text = movie.title
            self?.timeLabel.text = movie.date
            self?.descriptionText.text = movie.descript
        }
    }
}
