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
    
    let skylineCinemaItemsURL = "https://skylinecinema.ru/menu"
    let skylineCinemaMoviesURL = "https://skylinecinema.ru/movies"
    let skylineCinemaMembershipURL = "https://skylinecinema.ru/membership"
    let skylineCinemaAddressURL = "https://skylinecinema.ru/addresses"
    
    let vkURL = "https://vk.com/skyline.cinema"
    let igURL = "https://www.instagram.com/skyline.cinema/"
    let fbURL = "https://www.facebook.com/Автокинотеатр-SkylineCinema-1708504372569940"
    let tlgURL = "https://t.me/skylinecinema_bot"
    let safariURL = "http://skylinecinema.ru"
    
    let kinopoiskRatesURL = "https://rating.kinopoisk.ru/"
    let kinopoiskRatesURLXMLExtension = ".xml"
    let kinopoiskMovieDetailsURL = "https://www.kinopoisk.ru/film/"
    
    let wikiURL = "https://ru.wikipedia.org/wiki/"
    
    let buyTicketURL = "https://money.yandex.ru/new/transfer/a2w"
    
    let realm = try! Realm()
    let jsonManager = JSONManager()
    
    let networkActive = false
    
    func getItems() -> [Category]{
        var groupsOfItems = [Category]()
        do{
            try realm.write {
                let olderItems = realm.objects(Item.self)
                realm.delete(olderItems)
                if networkActive {
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
        if networkActive {
            Alamofire.request(skylineCinemaMoviesURL, method: .get).responseJSON {
                (response) in
                if response.result.isSuccess {
                    movies = self.jsonManager.parseJSONMovies(response: response)
                }
            }
        } else {
            movies = self.jsonManager.parseJSONMOCKMovies()
        }
        return movies
    }
    
    func getAddresses() -> [Address] {
        var addresses = [Address]()
        if networkActive {
            Alamofire.request(skylineCinemaAddressURL, method: .get).responseJSON {
                (response) in
                if response.result.isSuccess {
                    addresses = self.jsonManager.parseAddressJSON(response: response)
                }
            }
        } else {
            addresses = self.jsonManager.parseAddressJSONMock()
        }
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
