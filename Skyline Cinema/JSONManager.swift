//
//  JSONManager.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 15.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class JSONManager {
    
    func parseJSONItems(response: DataResponse<Any>) -> [Item]{
        var itemsFromJSON = [Item]()
        // parse JSON from server
        let jsonResponse: JSON = JSON(response.result.value!)
        print("JSON MENU RESPONSE: \(jsonResponse)")
        let itemsJSON = jsonResponse["itemsResponse"]
        
        // parse items from JSON
        for itemResponse in itemsJSON.arrayValue {
            let newItem = Item()
            newItem.title = itemResponse["title"].stringValue
            newItem.descript = itemResponse["description"].stringValue
            newItem.price = Double(itemResponse["price"].stringValue) ?? 0
            itemsFromJSON.append(newItem)
        }
        
        return itemsFromJSON
    }
    
    func parseMOCKJSONItems() -> [Item]{
        var itemsFromJSON = [Item]()
        var json: JSON?
        if let dataFromString = self.mockItemsJSON().data(using: .utf8, allowLossyConversion: false) {
            do {
                json = try JSON(data: dataFromString)
            } catch {
                print("ERROR Parsing Items JSON: \(error)")
            }
        }
        let jsonResponse: JSON = json!
        print("JSON MENU RESPONSE: \(jsonResponse)")
        let itemsJSON = jsonResponse["itemsResponse"]
        
        // parse items from JSON
        for itemResponse in itemsJSON.arrayValue {
            let newItem = Item()
            newItem.title = itemResponse["title"].stringValue
            newItem.descript = itemResponse["description"].stringValue
            newItem.price = Double(itemResponse["price"].stringValue) ?? 0
            itemsFromJSON.append(newItem)
        }
        
        return itemsFromJSON
    }
    
    func parseJSONMovies(response: DataResponse<Any>) -> [Movie] {
        // parse JSON from server
        var moviesFromJSON = [Movie]()
        let jsonResponse: JSON = JSON(response.result.value!)
        print("JSON MOVIES RESPONSE: \(jsonResponse)")
        let moviesJSON = jsonResponse["moviesResponse"]
        
        // parse items from JSON
        for movie in moviesJSON.arrayValue {
            let newMovie = Movie()
            newMovie.title = movie["title"].stringValue
            newMovie.descript = movie["description"].stringValue
            newMovie.rate = Double(movie["rate"].stringValue) ?? 0
            moviesFromJSON.append(newMovie)
        }
        return moviesFromJSON
    }
    
    func parseJSONMOCKMovies() -> [Movie] {
        var moviesFromJSON = [Movie]()
        var json: JSON?
        if let dataFromString = self.mockMoviesJSON().data(using: .utf8, allowLossyConversion: false) {
            do {
                json = try JSON(data: dataFromString)
            } catch {
                print("ERROR Parsing Movies JSON: \(error)")
            }
        }
        let jsonResponse: JSON = json!
        print("JSON MOVIES RESPONSE: \(jsonResponse)")
        let moviesJSON = jsonResponse["moviesResponse"]
        
        for movie in moviesJSON.arrayValue {
            let newMovie = Movie()
            newMovie.title = movie["title"].stringValue
            newMovie.descript = movie["description"].stringValue
            newMovie.rate = Double(movie["rate"].stringValue) ?? 0
            newMovie.id = movie["id"].intValue
            newMovie.kinopoiskId = movie["kinopoiskId"].stringValue
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            let date = dateFormatter.date(from: movie["date"].stringValue)!
            newMovie.date = date
            moviesFromJSON.append(newMovie)
        }
        return moviesFromJSON
    }
    
    func parseMovieDetailsJSONFromWIki(response: DataResponse<Any>, movie: TimeTableCellViewModel) -> [String: String] {
        var details = [String: String]()
        
        let jsonResponse: JSON = JSON(response.result.value!)
        print("JSON RESPONSE: \(jsonResponse)")
        let pageid = jsonResponse["query"]["pageids"][0].stringValue
        let imageURL = jsonResponse["query"]["pages"][pageid]["thumbnail"]["source"].stringValue
        let description = jsonResponse["query"]["pages"][pageid]["extract"].stringValue
        
        details[Constants.shared.description] = description
        details[Constants.shared.imageURL] = imageURL
        return details
    }
    
    func mockItemsJSON() -> String {
        return "{\"itemsResponse\":[{\"id\":1,\"title\":\"Попкорн-1\",\"description\":\"попкорн\",\"price\":350},{\"id\":2,\"title\":\"Попкорн-2\",\"description\":\"попкорн\",\"price\":350},{\"id\":3,\"title\":\"Попкорн-3\",\"description\":\"попкорн\",\"price\":350},{\"id\":4,\"title\":\"Попкорн-4\",\"description\":\"попкорн\",\"price\":250},{\"id\":5,\"title\":\"Попкорн-5\",\"description\":\"попкорн\",\"price\":250},{\"id\":6,\"title\":\"Попкорн-6\",\"description\":\"попкорн\",\"price\":150},{\"id\":7,\"title\":\"Попкорн-7\",\"description\":\"попкорн\",\"price\":150},{\"id\":15,\"title\":\"Пепси 0,5\",\"description\":\"Пепси же\",\"price\":100}]}"
    }
    
    func mockMoviesJSON() -> String {
        return "{\"moviesResponse\":[{\"kinopoiskId\":\"263531\",\"title\":\"Топ Ган\",\"date\":\"21.12.2019 20:30\",\"address\":\"Аэропорт 2/2\"},{\"kinopoiskId\":\"263531\",\"title\":\"Хатико\",\"date\":\"21.12.2019 22:00\",\"address\":\"Аэропорт 2/2\"},{\"kinopoiskId\":\"263531\",\"title\":\"Кто подставил Кролика Роджера\",\"date\":\"22.12.2019 20:30\",\"address\":\"Аэропорт 2/2\"},{\"kinopoiskId\":\"263531\",\"title\":\"Кто подставил Кролика Роджера\",\"date\":\"22.12.2019 22:00\",\"address\":\"Аэропорт 2/2\"},{\"kinopoiskId\":\"263531\",\"title\":\"Кто подставил Кролика Роджера\",\"date\":\"23.12.2019 20:30\",\"address\":\"Аэропорт 2/2\"},{\"kinopoiskId\":\"263531\",\"title\":\"Кто подставил Кролика Роджера\",\"date\":\"23.12.2019 22:00\",\"address\":\"Аэропорт 2/2\"},{\"kinopoiskId\":\"263531\",\"title\":\"Кто подставил Кролика Роджера\",\"date\":\"24.12.2019 20:30\",\"address\":\"Аэропорт 2/2\"},{\"kinopoiskId\":\"263531\",\"title\":\"Кто подставил Кролика Роджера\",\"date\":\"24.12.2019 22:30\",\"address\":\"Аэропорт 2/2\"},{\"kinopoiskId\":\"263531\",\"title\":\"Кто подставил Кролика Роджера\",\"date\":\"25.12.2019 20:30\",\"address\":\"Аэропорт 2/2\"},{\"kinopoiskId\":\"263531\",\"title\":\"Кто подставил Кролика Роджера\",\"date\":\"25.12.2019 22:30\",\"address\":\"Аэропорт 2/2\"}]}"
    }
}
