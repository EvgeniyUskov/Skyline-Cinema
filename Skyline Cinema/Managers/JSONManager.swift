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

import YandexCheckoutPayments
import YandexCheckoutPaymentsApi

class JSONManager {
    static var shared : JSONManager {
        return JSONManager()
    }
    
    private init() {}
    
    let mock = Mock()
    
    func parseJSONItems(response: DataResponse<Any>) -> [Category] {
        var itemsFromJSON = [Category]()
        let jsonResponse: JSON = JSON(response.result.value!)
        debugPrint("JSON MENU RESPONSE: \(jsonResponse)")
        let categoriesJSON = jsonResponse["itemsResponse"]
        // parse items from JSON
        for categoryJSON in categoriesJSON.arrayValue {
            let categoryName = categoryJSON["category"].stringValue
            var itemList = [Item]()
            
            for itemResponse in categoryJSON["items"].arrayValue {
                let newItem = Item()
                newItem.category = categoryName
                newItem.title = itemResponse["title"].stringValue
                newItem.descript = itemResponse["description"].stringValue
                newItem.price = Double(itemResponse["price"].stringValue) ?? 0
                itemList.append(newItem)
            }
            let category = Category(name: categoryName, items: itemList)
            itemsFromJSON.append(category)
        }
        return itemsFromJSON
    }
    
    func parseMOCKJSONItems() -> [Category] {
        var itemsFromJSON = [Category]()
        var json: JSON?
        if let dataFromString = mock.mockItemsJSON().data(using: .utf8, allowLossyConversion: false) {
            do {
                json = try JSON(data: dataFromString)
            } catch {
                print("ERROR Parsing Items JSON: \(error)")
            }
        }
        let jsonResponse: JSON = json!
        debugPrint("JSON MENU RESPONSE: \(jsonResponse)")
        let categoriesJSON = jsonResponse["itemsResponse"]
        
        // parse items from JSON
        for categoryJSON in categoriesJSON.arrayValue {
            let categoryName = categoryJSON["category"].stringValue
            var itemList = [Item]()
            for itemResponse in categoryJSON["items"].arrayValue {
                let newItem = Item()
                newItem.category = categoryName
                newItem.title = itemResponse["title"].stringValue
                newItem.descript = itemResponse["description"].stringValue
                newItem.price = Double(itemResponse["price"].stringValue) ?? 0
                itemList.append(newItem)
            }
            let category = Category(name: categoryName, items: itemList)
            itemsFromJSON.append(category)
        }
        return itemsFromJSON
    }
    
    func parseJSONMovies(response: DataResponse<Any>) -> [MovieDay] {
        // parse JSON from server
        var moviesFromJSON = [MovieDay]()
        let jsonResponse: JSON = JSON(response.result.value!)
        debugPrint("JSON MOVIES RESPONSE: \(jsonResponse)")
        let movieDaysJSON = jsonResponse["moviesResponse"]
        
        // parse items from JSON
        for movieDayJSON in movieDaysJSON["days"].arrayValue {
            let date = movieDayJSON["date"].stringValue
            var movieList = [Movie]()
            for movie in movieDayJSON["movies"].arrayValue {
                
                let newMovie = Movie()
                newMovie.title = movie["title"].stringValue
                newMovie.descript = movie["description"].stringValue
                newMovie.rate = Double(movie["rate"].stringValue) ?? 0
                movieList.append(newMovie)
            }
            let movieDay = MovieDay(date: date, movies: movieList)
            moviesFromJSON.append(movieDay)
        }
        return moviesFromJSON
    }
    
    func parseJSONMOCKMovies() -> [MovieDay] {
        var moviesFromJSON = [MovieDay]()
        var json: JSON?
        if let dataFromString = mock.mockMoviesJSON().data(using: .utf8, allowLossyConversion: false) {
            do {
                json = try JSON(data: dataFromString)
            } catch {
                print("ERROR Parsing Movies JSON: \(error)")
            }
        }
        let jsonResponse: JSON = json!
        debugPrint("JSON MOVIES RESPONSE: \(jsonResponse)")
        let movieDaysJSON = jsonResponse["moviesResponse"]
        
        for movieDayJSON in movieDaysJSON["days"].arrayValue {
            let date = movieDayJSON["date"].stringValue
            var movieList = [Movie]()
            for movie in movieDayJSON["movies"].arrayValue {
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
                movieList.append(newMovie)
            }
            let movieDay = MovieDay(date: date, movies: movieList)
            moviesFromJSON.append(movieDay)
        }
        
        return moviesFromJSON
    }
    
    func parseMovieDetailsJSONFromWIki(response: DataResponse<Any>, movie: TimeTableCellViewModel) -> [String: String] {
        var details = [String: String]()
        
        let jsonResponse: JSON = JSON(response.result.value!)
        debugPrint("JSON RESPONSE: \(jsonResponse)")
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
        debugPrint("JSON RESPONSE: \(jsonResponse)")
        let membershipResponse = jsonResponse["membership"]
        membershipDetails[Constants.qrURL] = membershipResponse[Constants.qrURL].stringValue
        membershipDetails[Constants.endDate] = membershipResponse[Constants.endDate].stringValue
        return membershipDetails
    }
    
    func parseMOCKMembershipURL() -> [String: String] {
        var membershipDetails = [String: String]()
        var json: JSON?
        if let dataFromString = mock.mockMembershipJSON().data(using: .utf8, allowLossyConversion: false) {
            do {
                json = try JSON(data: dataFromString)
            } catch {
                print("ERROR Parsing Movies JSON: \(error)")
            }
        }
        let jsonResponse: JSON = json!
        debugPrint("JSON RESPONSE: \(jsonResponse)")
        let membershipResponse = jsonResponse["membershipResponse"]
        membershipDetails[Constants.qrURL] = membershipResponse[Constants.qrURL].stringValue
        membershipDetails[Constants.endDate] = membershipResponse[Constants.endDate].stringValue
        return membershipDetails
    }
    
    func parseAddressJSON(response: DataResponse<Any>) -> [Address] {
        var addresses = [Address]()
        let jsonResponse: JSON = JSON(response.result.value!)
        debugPrint("JSON ADDRESS RESPONSE: \(jsonResponse)")
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
        if let dataFromString = mock.mockAddressJSON().data(using: .utf8, allowLossyConversion: false) {
            do {
                json = try JSON(data: dataFromString)
            } catch {
                print("ERROR Parsing Address JSON: \(error)")
            }
        }
        let jsonResponse: JSON = json!
        debugPrint("JSON RESPONSE: \(jsonResponse)")
        let addressJSON = jsonResponse["addressResponse"]
        
        for itemResponse in addressJSON.arrayValue {
            var address = Address()
            address.address = itemResponse[Constants.addressAddress].stringValue
            address.description = itemResponse[Constants.addressDescription].stringValue
            address.phoneNumber = itemResponse[Constants.addressPhoneNumber].stringValue
            addresses.append(address)
        }
        
        return addresses
    }
    
    func parsePaymentJSON(response: DataResponse<Any>) -> Payment {
        let jsonResponse: JSON = JSON(response.result.value!)
        debugPrint("JSON Payment RESPONSE: \(jsonResponse)")
        let id = jsonResponse["id"].stringValue
        let status = jsonResponse["status"].stringValue
        let paid = jsonResponse["paid"].boolValue
        let amount = Amount(value: Decimal(jsonResponse["amount"]["value"].doubleValue), currency: .rub)
        //        jsonResponse["amount"]["currency"])
        //        let confirmation = Confirmation(type: jsonResponse["confirmation"]["type"], confirmationUrl: jsonResponse["confirmation"]["confirmation_url"])
        let createdAt = DateUtils.stringToDate(dateString: jsonResponse["created_at"].stringValue)
        let description = jsonResponse["description"].stringValue
        
        let payment = Payment(id: id, status: status, paid: paid, amount: amount, createdAt: createdAt, description: description)
        
        return payment
    }
    
    // PAYMENT
    //        {
    //          "id": "23d93cac-000f-5000-8000-126628f15141",
    //          "status": "pending",
    //          "paid": false,
    //          "amount": {
    //            "value": "2.00",
    //            "currency": "RUB"
    //          },
    //          "confirmation": {
    //            "type": "redirect",
    //            "confirmation_url": "<Ссылка для прохождения 3-D Secure>"
    //          },
    //          "created_at": "2019-01-22T14:30:45.129Z",
    //          "description": "Заказ №72",
    //          "metadata": {},
    //          "recipient": {
    //            "account_id": "100001",
    //            "gateway_id": "1000001"
    //          },
    //          "refundable": false,
    //          "test": false
    //        }
    
}
