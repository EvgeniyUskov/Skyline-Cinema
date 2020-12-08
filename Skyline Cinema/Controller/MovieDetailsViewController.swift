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
    
    var movie : TimeTableCellViewModel?
    
    @IBOutlet weak var rateKpLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var movieImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        getRates()
        getMovieDetailsFromWiki()
//        getMovieDetailsFromKinopoisk()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTicketPurchase" {
            let buyTicketController = segue.destination as! BuyTicketViewController
            buyTicketController.movie = movie
        }
    }
    
    func getRates(){
        if let movieLocal = self.movie {
            let xmlManager = XMLManager()
            var rates = [String: String]()
            Alamofire.request(Routes.getKinopoiskRatesURL(kinopoiskMovieId: movieLocal.kinopoiskId), method: .get).responseString { (response) in
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
            let headers: HTTPHeaders = [
                "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36"
            ]
            Alamofire.request(Routes.getKinopoiskMovieDetailsURL(kinopoiskMovieId: movieLocal.kinopoiskId), method: .get, headers: headers).responseString { (response) in
                if response.result.isSuccess {
                        print("MOVIE DETAILS KINOPOISK SUCCESS: \(response)" )
                        details[Constants.description] = kinopoiskParser.getDescription(response: response)
                            details[Constants.imageURL] =  kinopoiskParser.getImageURL(response: response)
                        DispatchQueue.main.async {
                            movieLocal.setDetails(details: details)
                            self.setUpDescriptionAndImageURL(movie: movieLocal)
                        }
                    }
                }
             SVProgressHUD.dismiss()
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
            Alamofire.request(Routes.wikiURL, method: .get, parameters: parameters).responseJSON { (response) in
                if response.result.isSuccess {
                    print("MOVIE DETAILS SUCCESS: \(response)" )
                    details = jsonManager.parseMovieDetailsJSONFromWIki(response: response, movie: movieLocal)
                    DispatchQueue.main.async {
                        movieLocal.setDetails(details: details)
                        self.setUpDescriptionAndImageURL(movie: movieLocal)
                    }
                }
            }
            SVProgressHUD.dismiss()
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
