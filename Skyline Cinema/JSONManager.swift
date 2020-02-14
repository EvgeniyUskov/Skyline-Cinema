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
    
    func parseJSONItems(response: DataResponse<Any>) -> [String: [Item]] {
        var itemsFromJSON = [String: [Item]]()
        // parse JSON from server
        let jsonResponse: JSON = JSON(response.result.value!)
        print("JSON MENU RESPONSE: \(jsonResponse)")
        let categoriesJSON = jsonResponse["itemsResponse"]
        // parse items from JSON
        for categoryJSON in categoriesJSON.arrayValue {
            let category = categoryJSON["category"].stringValue
            var itemList = [Item]()
            
            for itemResponse in categoryJSON["items"].arrayValue {
                let newItem = Item()
                newItem.title = itemResponse["title"].stringValue
                newItem.descript = itemResponse["description"].stringValue
                newItem.price = Double(itemResponse["price"].stringValue) ?? 0
                itemList.append(newItem)
            }
            itemsFromJSON[category] = itemList
        }
        return itemsFromJSON
    }
    
    func parseMOCKJSONItems() -> [String: [Item]] {
        var itemsFromJSON = [String: [Item]]()
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
        let categoriesJSON = jsonResponse["itemsResponse"]
        
        // parse items from JSON
        for categoryJSON in categoriesJSON.arrayValue {
            let category = categoryJSON["category"].stringValue
            var itemList = [Item]()
            for itemResponse in categoryJSON["items"].arrayValue {
                let newItem = Item()
                newItem.category = category
                newItem.title = itemResponse["title"].stringValue
                newItem.descript = itemResponse["description"].stringValue
                newItem.price = Double(itemResponse["price"].stringValue) ?? 0
                itemList.append(newItem)
            }
            itemsFromJSON[category] = itemList
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
            dateFormatter.locale = Locale(identifier: "ru_RU_POSIX")
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
        
        details[Constants.description] = description
        details[Constants.imageURL] = imageURL
        return details
    }
    
    func parseMembershipURL(response: DataResponse<Any>) -> [String: String] {
        var membershipDetails = [String: String]()
        let jsonResponse: JSON = JSON(response.result.value!)
        print("JSON RESPONSE: \(jsonResponse)")
        let membershipResponse = jsonResponse["membership"]
        membershipDetails[Constants.qrURL] = membershipResponse[Constants.qrURL].stringValue
        membershipDetails[Constants.endDate] = membershipResponse[Constants.endDate].stringValue
        return membershipDetails
    }
    
    func parseMOCKMembershipURL() -> [String: String] {
        var membershipDetails = [String: String]()
        var json: JSON?
        if let dataFromString = self.mockMembershipJSON().data(using: .utf8, allowLossyConversion: false) {
            do {
                json = try JSON(data: dataFromString)
            } catch {
                print("ERROR Parsing Movies JSON: \(error)")
            }
        }
        let jsonResponse: JSON = json!
        print("JSON RESPONSE: \(jsonResponse)")
        let membershipResponse = jsonResponse["membershipResponse"]
        membershipDetails[Constants.qrURL] = membershipResponse[Constants.qrURL].stringValue
        membershipDetails[Constants.endDate] = membershipResponse[Constants.endDate].stringValue
        return membershipDetails
    }
    
    func parseAddressJSON(response: DataResponse<Any>) -> [Address] {
        var addresses = [Address]()
        let jsonResponse: JSON = JSON(response.result.value!)
        print("JSON ADDRESS RESPONSE: \(jsonResponse)")
        let addressJSON = jsonResponse["addressResponse"]
        
        for itemResponse in addressJSON.arrayValue {
            var address = Address()
            address.address = itemResponse[Constants.addressAddress].stringValue
            address.description = itemResponse[Constants.addressDescription ].stringValue
            addresses.append(address)
        }
        
        return addresses
    }
    
    func parseAddressJSONMock() -> [Address] {
        var json: JSON?
        var addresses = [Address]()
        if let dataFromString = self.mockAddressJSON().data(using: .utf8, allowLossyConversion: false) {
            do {
                json = try JSON(data: dataFromString)
            } catch {
                print("ERROR Parsing Address JSON: \(error)")
            }
        }
        let jsonResponse: JSON = json!
        print("JSON RESPONSE: \(jsonResponse)")
        let addressJSON = jsonResponse["addressResponse"]
        
        for itemResponse in addressJSON.arrayValue {
            var address = Address()
            address.address = itemResponse[Constants.addressAddress].stringValue
            address.description = itemResponse[Constants.addressDescription ].stringValue
            address.phoneNumber = itemResponse[Constants.addressPhoneNumber ].stringValue
            addresses.append(address)
        }
        
        return addresses
    }
    
    func mockItemsJSON() -> String {
        return "{\"itemsResponse\":[{\"category\":\"Попкорн\",\"items\":[{\"id\":1,\"title\":\"Попкорн Большой Сладкий\",\"description\":\"Попкорн с добавлением знаменитого сахарного сиропа с южных склонов Перинейских гор и нотками сыра Камамбер\",\"price\":350},{\"id\":2,\"title\":\"Попкорн Большой Соленый\",\"description\":\"Попкорн с добавлением знаменитого сахарного сиропа с южных склонов Перинейских гор и нотками сыра Камамбер\",\"price\":350},{\"id\":3,\"title\":\"Попкорн Средний Сладкий\",\"description\":\"Попкорн с добавлением знаменитого сахарного сиропа с южных склонов Перинейских гор и нотками сыра Камамбер\",\"price\":250},{\"id\":4,\"title\":\"Попкорн Средний Соленый\",\"description\":\"Попкорн с добавлением знаменитого сахарного сиропа с южных склонов Перинейских гор и нотками сыра Камамбер\",\"price\":250},{\"id\":5,\"title\":\"Попкорн Маленький Сладкий\",\"description\":\"Попкорн с добавлением знаменитого сахарного сиропа с южных склонов Перинейских гор и нотками сыра Камамбер\",\"price\":150},{\"id\":6,\"title\":\"Попкорн Маленький Соленый\",\"description\":\"Попкорн с добавлением знаменитого сахарного сиропа с южных склонов Перинейских гор и нотками сыра Камамбер\",\"price\":150}]},{\"category\":\"Напитки\",\"items\":[{\"id\":10,\"title\":\"Кофе Капуччино\",\"description\":\"Черный кофе с взбитой молочной пенкой\",\"price\":100},{\"id\":11,\"title\":\"Кофе Латте черный\",\"description\":\"Черный кофе с добавлением молока\",\"price\":100},{\"id\":12,\"title\":\"Кофе Американо\",\"description\":\"Черный кофе без молока\",\"price\":100},{\"id\":13,\"title\":\"Пепси 0,5л\",\"description\":\"Pepsi\",\"price\":100},{\"id\":14,\"title\":\"Кока-кола 0,5л\",\"description\":\"Coca-Cola\",\"price\":100},{\"id\":15,\"title\":\"Пепси 1л\",\"description\":\"Pepsi\",\"price\":100},{\"id\":16,\"title\":\"Кока-кола 1л\",\"description\":\"Coca-Cola\",\"price\":100},{\"id\":17,\"title\":\"Минеральная вода 0,5л\",\"description\":\"Негазированная питьевая вода\",\"price\":100},{\"id\":18,\"title\":\"Минеральная вода 0,5л\",\"description\":\"Газированная питьевая вода\",\"price\":100}]},{\"category\":\"Шоколад\",\"items\":[{\"id\":20,\"title\":\"Сникерс\",\"description\":\"Оригинальный\",\"price\":100},{\"id\":21,\"title\":\"Твикс\",\"description\":\"Оригинальный\",\"price\":100},{\"id\":22,\"title\":\"Альпер гольд\",\"description\":\"Соленый арахис\",\"price\":100},{\"id\":23,\"title\":\"Милка\",\"description\":\"С фундуком\",\"price\":100}]},{\"category\":\"Чипсы\",\"items\":[{\"id\":30,\"title\":\"Принглз\",\"description\":\"Оригинальные\",\"price\":100},{\"id\":31,\"title\":\"Принглз\",\"description\":\"Сыр\",\"price\":100},{\"id\":32,\"title\":\"Лейс\",\"description\":\"Сметана и чеснок\",\"price\":100},{\"id\":33,\"title\":\"Лейс\",\"description\":\"Краб\",\"price\":100},{\"id\":34,\"title\":\"Лейс\",\"description\":\"Бекон\",\"price\":100},{\"id\":35,\"title\":\"Лейс\",\"description\":\"С солью\",\"price\":100}]},{\"category\":\"Кальяны\",\"items\":[{\"id\":40,\"title\":\"Darkside\",\"description\":\"Легкий\",\"price\":800},{\"id\":41,\"title\":\"Darkside\",\"description\":\"Средний\",\"price\":1000},{\"id\":42,\"title\":\"Darkside\",\"description\":\"Крепкий\",\"price\":1200},{\"id\":43,\"title\":\"Must Have\",\"description\":\"Легкий\",\"price\":1000},{\"id\":44,\"title\":\"Must Have\",\"description\":\"Средний\",\"price\":1300},{\"id\":45,\"title\":\"Must Have\",\"description\":\"Крепкий\",\"price\":1500}]}]}"
    }
    
    func mockMoviesJSON() -> String {
        return "{\"moviesResponse\":[{\"kinopoiskId\":\"263531\",\"title\":\"Топ Ган\",\"date\":\"21.12.2019 20:30\",\"address\":\"Аэропорт 2/2\"},{\"kinopoiskId\":\"387556\",\"title\":\"Хатико - самый верный друг\",\"date\":\"21.12.2019 22:00\",\"address\":\"Аэропорт 2/2\"},{\"kinopoiskId\":\"7108\",\"title\":\"Кто подставил Кролика Роджера\",\"date\":\"22.12.2019 20:30\",\"address\":\"Аэропорт 2/2\"},{\"kinopoiskId\":\"4807\",\"title\":\"Не грози южному централу, попивая сок у себя в квартале\",\"date\":\"22.12.2019 22:00\",\"address\":\"Аэропорт 2/2\"},{\"kinopoiskId\":\"1111004\",\"title\":\"Хищные птицы\",\"date\":\"23.12.2019 20:30\",\"address\":\"Аэропорт 2/2\"},{\"kinopoiskId\":\"263531\",\"title\":\"Кто подставил Кролика Роджера\",\"date\":\"23.12.2019 22:00\",\"address\":\"Аэропорт 2/2\"},{\"kinopoiskId\":\"263531\",\"title\":\"Мстители\",\"date\":\"24.12.2019 20:30\",\"address\":\"Аэропорт 2/2\"},{\"kinopoiskId\":\"263531\",\"title\":\"Кто подставил Кролика Роджера\",\"date\":\"24.12.2019 22:30\",\"address\":\"Аэропорт 2/2\"},{\"kinopoiskId\":\"263531\",\"title\":\"Кто подставил Кролика Роджера\",\"date\":\"25.12.2019 20:30\",\"address\":\"Аэропорт 2/2\"},{\"kinopoiskId\":\"263531\",\"title\":\"Кто подставил Кролика Роджера\",\"date\":\"25.12.2019 22:30\",\"address\":\"Аэропорт 2/2\"}]}"
    }
    
    func mockMembershipJSON() -> String {
        return "{\"membershipResponse\":{\"link\":\"www.skylinecinema.ru/membership/58\",\"endDate\":\"20.12.2030\"}}"
    }
    
    func mockAddressJSON() -> String {
        return "{\"addressResponse\":[{\"address\":\"Аэропорт 2/2\",\"description\":\"АЭЭЭРОПОООРТ СТОЮ У ТРАПА САМОЛЕЕЕТА. АЭЭЭЭРОПОРТ ПО МНЕ КУЧАЕТ ВЫСОТААА. АЭРОПОРТ ГЛЯДИ МЕНЯ ВСТРЕЧАЕТ КТОО-ТО. НА ТОМ КОНЦЕ ВОЗДУШНОГОООО МООООСТА.\", \"phoneNumber\":\"89991112233\"}, {\"address\":\"Аэропорт Толмачево 1\",\"description\":\"АЭЭЭРОПОООРТ СТОЮ У ТРАПА САМОЛЕЕЕТА. АЭЭЭЭРОПОРТ ПО МНЕ КУЧАЕТ ВЫСОТААА. АЭРОПОРТ ГЛЯДИ МЕНЯ ВСТРЕЧАЕТ КТОО-ТО. НА ТОМ КОНЦЕ ВОЗДУШНОГОООО МООООСТА.\", \"phoneNumber\":\"81112223344\"}]}"
    }
}
