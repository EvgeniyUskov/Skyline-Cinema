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

class MovieDetailsViewController: UIViewController {
    
    let networkManager = NetworkManager()
    
    
    
    
    var movie : TimeTableCellViewModel?
    
    @IBOutlet weak var rateKpLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var movieImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let rates = self.networkManager.getMovieRates(kinopoiskId: movieLocal.kinopoiskId)
        getRates()
        //        getMovieDetailsFromWiki()
        getMovieDetailsFromKinopoisk()
    }
    
    func getRates(){
        if let movieLocal = self.movie {
            let xmlManager = XMLManager()
            var rates = [String: String]()
            Alamofire.request(networkManager.getKinopoiskRatesURL(kinopoiskMovieId: movieLocal.kinopoiskId), method: .get).responseString { (response) in
                print("RATES SUCCESS: \(response)")
                rates = xmlManager.parseRatesXML(response: response)
                DispatchQueue.main.async {
                    movieLocal.setRates(rates: rates)
                    self.setUpRates(movie: movieLocal)
                }
            }
            
            
        }
    }
    
    func getMovieDetailsFromKinopoisk() {
        if let movieLocal = self.movie {
            let kinopoiskParser = KinopoiskHTMLParser()
            var details = [String: String]()
            Alamofire.request(networkManager.getKinopoiskMovieDetailsURL(kinopoiskMovieId: movieLocal.kinopoiskId), method: .get).responseString { (response) in
                if response.result.isSuccess {
                    print("MOVIE DETAILS KINOPISK SUCCESS: \(response)" )
                    details[Constants.shared.description] = kinopoiskParser.getDescription(response: response)
                        details[Constants.shared.imageURL] =  kinopoiskParser.getImageURL(response: response)
                    
                    DispatchQueue.main.async {
                        movieLocal.setDetailsFromWiki(details: details)
                        self.setUpDescriptionAndImageURL(movie: movieLocal)
                    }
                }
            }
        }
    }
    
    
    func getMovieDetailsFromWiki() {
        if let movieLocal = self.movie {
            let jsonManager = JSONManager()
            let parameters : [String:String] = [
                "format" : "json",
                "action" : "query",
                "prop" : "extracts|pageimages",
                "exintro" : "",
                "explaintext" : "",
                "titles" : movieLocal.title,
                "indexpageids" : "",
                "redirects" : "1",
                "pithumbsize" : "500",
            ]
            var details = [String: String]()
            Alamofire.request(networkManager.wikiURL, method: .get, parameters: parameters).responseJSON { (response) in
                if response.result.isSuccess {
                    print("MOVIE DETAILS SUCCESS: \(response)" )
                    details = jsonManager.parseMovieDetailsJSONFromWIki(response: response, movie: movieLocal)
                    DispatchQueue.main.async {
                        movieLocal.setDetailsFromWiki(details: details)
                        self.setUpDescriptionAndImageURL(movie: movieLocal)
                    }
                }
            }
        }
    }
    
    func setUpRates(movie: TimeTableCellViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.rateKpLabel.text = movie.rateKp
            self?.titleLabel.text = movie.title
            self?.timeLabel.text = movie.date
        }
    }
    
    
    func setUpDescriptionAndImageURL(movie: TimeTableCellViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.descriptionText.text = movie.descript
            self?.movieImageView.sd_setImage(with: URL(string: movie.imageURL ?? ""), completed: nil)
        }
    }
    
}
