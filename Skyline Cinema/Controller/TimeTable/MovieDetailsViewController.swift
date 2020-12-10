//
//  MovieInfoViewController.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 14.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SVProgressHUD

class MovieDetailsViewController: UIViewController {
    
    var movie : MovieViewModelProtocol?
    
    @IBOutlet weak var rateKpLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var movieImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        
        if var movieLocal = self.movie {
            getRates(movie: movieLocal)
            NetworkManager.shared.getMovieDetailsFromWiki(movie: movieLocal, completion: {
                [unowned self]
                details in
                movieLocal.description = details.description
                movieLocal.imageURL = details.imageUrl
                self.setUpDescriptionAndImageURL(movie: movieLocal)
                SVProgressHUD.dismiss()
            })
        }
        //        getMovieDetailsFromKinopoisk()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTicketPurchase" {
            let buyTicketController = segue.destination as! BuyTicketViewController
            buyTicketController.movie = movie
        }
    }
    
    func getRates(movie: MovieViewModelProtocol){
            NetworkManager.shared.getRates(movie: movie, completion: {
                                            [unowned self]
                                            rates in
                movie.setRates(rates: rates)
                self.setUpRates(movie: movie)
            })
    }
    
//    func getMovieDetailsFromKinopoisk() {
//        if let movieLocal = self.movie {
//            NetworkManager.shared.getMovieDetailsFromKinopoisk(movie: movieLocal)
//            SVProgressHUD.dismiss()
//        }
//    }
    
    func setUpRates(movie: MovieViewModelProtocol) {
        DispatchQueue.main.async {
            [unowned self] in
            self.rateKpLabel.text = movie.kpRate
            self.titleLabel.text = movie.title
            self.timeLabel.text = movie.date
        }
    }
    
    
    func setUpDescriptionAndImageURL(movie: MovieViewModelProtocol) {
        DispatchQueue.main.async {
            [unowned self] in
            self.descriptionText.text = movie.description
            self.descriptionText.isHidden = false
            self.movieImageView.sd_setImage(with: URL(string: movie.imageURL ?? ""), completed: nil)
        }
    }
    
}
