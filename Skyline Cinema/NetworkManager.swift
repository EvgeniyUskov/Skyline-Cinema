//
//  NetworkManager.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 06.02.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SVProgressHUD

struct NetworkManager {
    var defaults = UserDefaults.standard
    
    let skylineCinemaItemsURL = "https://skylinecinema.ru/menu"
    let skylineCinemaMoviesURL = "https://skylinecinema.ru/movies"
    let skylineCinemaMembershipURL = "https://skylinecinema.ru/membership"
    let skylineCinemaAddressRequestURL = "https://skylinecinema.ru/addresses"
    
    let skylineCinemaOrderRequestURL = "https://skylinecinema.ru/order"
    let skylineCinemaTicketRequestURL = "https://skylinecinema.ru/ticket"
    
    let vkURL = "https://vk.com/skyline.cinema"
    let igURL = "https://www.instagram.com/skyline.cinema/"
    let fbURL = "https://www.facebook.com/Автокинотеатр-SkylineCinema-1708504372569940"
    let tlgURL = "https://t.me/skylinecinema_bot"
    let safariURL = "http://skylinecinema.ru"
    
    let kinopoiskRatesURL = "https://rating.kinopoisk.ru/"
    let kinopoiskRatesURLXMLExtension = ".xml"
    let kinopoiskMovieDetailsURL = "https://www.kinopoisk.ru/film/"
    
    let wikiURL = "https://ru.wikipedia.org/w/api.php"
    
    let buyTicketURL = "https://money.yandex.ru/new/transfer/a2w"
    
    let realm = try! Realm()
    let jsonManager = JSONManager()
    
    func getItems() -> [Category]{
        var groupsOfItems = [Category]()
        do{
            try realm.write {
                let olderItems = realm.objects(Item.self)
                realm.delete(olderItems)
                if Constants.networkActive {
                    Alamofire.request(skylineCinemaItemsURL, method: .get).responseJSON {
                        (response) in
                        if response.result.isSuccess {
                            groupsOfItems = self.jsonManager.parseJSONItems(response: response)
                            for category in groupsOfItems {
                                self.realm.add(category.items)
                            }
                        }
                    }
                } else {
                    groupsOfItems = jsonManager.parseMOCKJSONItems()
                    for category in groupsOfItems {
                        self.realm.add(category.items)
                    }
                }
            }
        }
        catch {
            print("Error getting Items: \(error)")
        }
        
        SVProgressHUD.dismiss()
        return groupsOfItems
    }
    
    func getMovies() -> [MovieDay] {
        var movies = [MovieDay]()
        if Constants.networkActive {
            Alamofire.request(skylineCinemaMoviesURL, method: .get).responseJSON {
                (response) in
                if response.result.isSuccess {
                    movies = self.jsonManager.parseJSONMovies(response: response)
                }
            }
        } else {
            movies = self.jsonManager.parseJSONMOCKMovies()
        }
        SVProgressHUD.dismiss()
        return movies
    }
    
    func getAddresses() -> [Address] {
        var addresses = [Address]()
        if let city = defaults.string(forKey: Constants.propCity) {
            let parameters = ["city": city]
            if Constants.networkActive {
                Alamofire.request(skylineCinemaAddressRequestURL,
                                  method: .post,
                    parameters: parameters,
                    encoding: JSONEncoding.default).responseJSON { response in
                        debugPrint(response)
                        if response.result.isSuccess {
                            addresses = self.jsonManager.parseAddressJSON(response: response)
                        }
                }
            } else {
                addresses = self.jsonManager.parseAddressJSONMock()
            }
        }
        SVProgressHUD.dismiss()
        return addresses
    }
    
    func getKinopoiskRatesURL (kinopoiskMovieId: String) -> String {
        return kinopoiskRatesURL +
            kinopoiskMovieId +
        kinopoiskRatesURLXMLExtension
    }
    
    func getKinopoiskMovieDetailsURL(kinopoiskMovieId: String) -> String {
        return kinopoiskMovieDetailsURL +
        kinopoiskMovieId
    }
}
