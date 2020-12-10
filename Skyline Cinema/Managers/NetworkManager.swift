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

struct NetworkManager {
    static var shared : NetworkManager {
        return NetworkManager()
    }
    
    private init () {}
    
    private var defaults = UserDefaults.standard
    
    func getItems(completion: @escaping ([Category]) -> ()) {
        //TODO: delete if else
        if Constants.isNetworkActive {
            if let url = URL(string: Routes.skylineCinemaItemsURL) {
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) {
                    (data, response, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    if let safeData = data {
                        if let categoriesFromJSON = JSONManager.shared.parseJSONItems(data: safeData) {
                            completion(categoriesFromJSON)
                        }
                    }
                }
                task.resume()
            }
        } else {
            var categories = [Category]()
            categories = JSONManager.shared.parseMOCKJSONItems()
            completion(categories)
        }
    }
    
    func getMovies(completion: @escaping ([MovieDay]) -> ()) {
        //TODO: delete if else
        if Constants.isNetworkActive {
            if let url = URL(string: Routes.skylineCinemaMoviesURL) {
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) {
                    (data, response, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    if let safeData = data {
                        if let movies = JSONManager.shared.parseJSONMovies(data: safeData) {
                            completion(movies)
                        }
                    }
                }
                task.resume()
            }
        } else {
            var movies = [MovieDay]()
            movies = JSONManager.shared.parseJSONMOCKMovies()
            completion(movies)
        }
    }
    
    func getMovieDetailsFromWiki(movie: MovieViewModelProtocol, completion: @escaping (MovieDetails) -> ()) {
        let parameters : [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "extracts|pageimages",
            "exintro" : "",
            "explaintext" : "",
            "titles" : movie.title,
            "indexpageids" : "",
            "redirects" : "1",
            "pithumbsize" : "500",
        ]
        
        if var url = URL(string: Routes.wikiURL) {
            url = url.appending(parameters)
            var request = URLRequest(url: url)
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return}
            request.httpBody = httpBody
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {
                (data, response, error) in
                if let error = error {
                    print(error)
                    return
                }
                if let safeData = data {
                    if let details = JSONManager.shared.parseMovieDetailsJSONFromWIki(data: safeData, movie: movie) {
                        completion(details)
                    }
                }
            }
            task.resume()
        }
    }
    
    //    func getMovieDetailsFromKinopoisk(movie: TimeTableCellViewModel, completion: @escaping (MovieDetails) -> ()) {
    //        let kinopoiskParser = KinopoiskHTMLParser()
    //        var details = [String: String]()
    //        let headers: HTTPHeaders = [
    //            "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36"
    //        ]
    //        AF.request(Routes.getKinopoiskMovieDetailsURL(kinopoiskMovieId: movie.kinopoiskId), method: .get, headers: headers).responseString { (response) in
    //            switch response.result {
    //            case .success:
    //                    print("MOVIE DETAILS KINOPOISK SUCCESS: \(response)" )
    //                    details[Constants.description] = kinopoiskParser.getDescription(response: response)
    //                    details[Constants.imageURL] =  kinopoiskParser.getImageURL(response: response)
    //
    //                    completion(details)
    //                    DispatchQueue.main.async {
    //                        movie.setDetails(details: details)
    //                        self.setUpDescriptionAndImageURL(movie: movie)
    //                    }
    //
    //            case let .failure(error):
    //                print(error)
    //            }
    //        }
    //    }
    
    func getRates(movie: MovieViewModelProtocol, completion: @escaping (Rates) -> ()) {
        //TODO: Delete this if else
        if Constants.isNetworkActive {
            if let url = URL(string: Routes.getKinopoiskRatesURL(kinopoiskMovieId: movie.kinopoiskId)) {
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) {
                    (data, response, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    if let safeData = data {
                        if let rates = XMLManager.shared.parseRatesXML(data: safeData){
                            completion(rates)
                        }
                    }
                }
                task.resume()
            }
        } else {
            if let url = URL(string: Routes.getKinopoiskRatesURL(kinopoiskMovieId: "2318")) {
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) {
                    (data, response, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    if let safeData = data {
                        if let rates = XMLManager.shared.parseRatesXML(data: safeData){
                            completion(rates)
                        }
                    }
                }
                task.resume()
            }
        }
        
    }
    
    func getAddresses(completion: @escaping ([Address]) -> ()) {
        if let city = defaults.string(forKey: Constants.propCity) {
            let parameters = ["city": city]
            //TODO: delete if else
            if Constants.isNetworkActive {
                if let url = URL(string: Routes.skylineCinemaAddressURL) {
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return}
                    request.httpBody = httpBody
                    
                    let session = URLSession(configuration: .default)
                    let task = session.dataTask(with: request) {
                        (data, response, error) in
                        if let error = error {
                            print(error)
                            return
                        }
                        if let safeData = data {
                            if let addresses = JSONManager.shared.parseAddressJSON(data: safeData) {
                                completion(addresses)
                            }
                        }
                    }
                    task.resume()
                }
            } else {
                var addresses = [Address]()
                addresses = JSONManager.shared.parseAddressJSONMock()
                completion(addresses)
            }
        }
    }
    
    func getMembership(licensePlateNumber: String, completion: @escaping (Membership) -> ()) {
        //TODO: delete if else
        if Constants.isNetworkActive {
            if let url = URL(string: Routes.skylineCinemaMembershipURL) {
                
                let parameters = ["licensePlateNumber": licensePlateNumber]
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
                request.httpBody = httpBody
                
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: request) {
                    (data, response, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    if let safeData = data {
                        if let membership = JSONManager.shared.parseMembershipJSON(data: safeData) {
                            completion(membership)
                        }
                    }
                }
                task.resume()
            }
        }
        
        else {
            let membershipDetails: [String: String] = JSONManager.shared.parseMOCKMembershipURL()
            if let url = membershipDetails[Constants.qrURL],
               let endDate = membershipDetails[Constants.endDate] {
                let membership = Membership(url: url, date: endDate)
                completion(membership)
            }
        }
        
    }
    
    func applyPayment(order: Order, completion: @escaping (OrderResponse?) -> ()) {
        
        if let url = URL(string: Routes.skylineCinemaItemsURL) {
            let orderRequest = OrderRequest(order: order)
            let parameters = orderRequest.transformToParameters()
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
            request.httpBody = httpBody
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) {
                (data, response, error) in
                if let error = error {
                    print(error)
                    return
                }
                if let safeData = data {
                    if let orderCompletedResponse = JSONManager.shared.parseJSONOrderResponse(data: safeData) {
                        completion(orderCompletedResponse)
                    } else {
                        completion(nil) }
                }
            }
            task.resume()
        }
    }
    
    //    func createPayment(paymentToken: Tokens, amount: Amount, description: String, completion: @escaping (Payment) -> Void) {
    //        let idempotenceKey = UUID()
    //
    //        let headers : [String: Any] = [
    //            "Idempotence-Key" : idempotenceKey
    //        ]
    //
    //        struct PaymentMethodData : Encodable {
    //            var type: String
    //        }
    //        let paymentMethodData = PaymentMethodData(type: "bank_card")
    //
    //        struct Confirmation : Encodable {
    //            var type: String
    //            var enforce: Bool
    //            var returnUrl: String
    //        }
    //        let confirmation = Confirmation(type: "redirect",
    //                                        enforce: false,
    //                                        returnUrl: Routes.skyLineCinemaSuccessPaymentURL)
    //
    //        let params : [String: Any] = [
    //            "payment_token": paymentToken,
    //            "amount": amount,
    //            "payment_method_data": paymentMethodData,
    //            "confirmation": confirmation,
    //            "capture": true,
    //            "description": description
    //        ]
    //        let cred = URLCredential(user: Constants.shopId , password: Constants.mobileSDKApiKey, persistence: .forSession)
    //        Alamofire.request(Routes.yandexPaymentURL, method: .post, parameters: params, headers: headers as! HTTPHeaders)
    //            .authenticate(usingCredential: cred)
    //            .responseJSON {
    //            (response) in
    //
    //            let payment = self.JSONManager.shared.parsePaymentJSON(response: response)
    //            completion(payment)
    //
    //        }
    //
    // REQUEST
    //        curl https://payment.yandex.net/api/v3/payments \
    //        -X POST \
    //        -u <Идентификатор магазина>:<Секретный ключ> \
    //        -H 'Idempotence-Key: <Ключ идемпотентности>' \
    //        -H 'Content-Type: application/json' \
    //        -d '{
    //              "payment_token": "eyJ0eXBlIjoiY2hlY2tvdXRfanNfYmFua19jYXJkIiwiZW5jcnlwdGVkIjoiMFk3Q3dVVXFVSUE0bXVUWW5EVXhBRG9PUFFCRHByQ3F6Y0cvcGw5SDFZV0xKejROaS9wVkZ0amhmT3N1b1NzVGp2cFJzYkRxSTdLWStYNjZjdW45STczTC8zQXFPOGVwV0dtSFEyV1pXR1lHM3pNdUxyNHp1WmJzMW85bDh5czdjT0ZuMEc5T3hma0kyNitQcXBuSGU3NGZwYzRXU1l2TUh4MFpyYVdRNW5UdFlDVWQyZz09IiwiaW5pdFZlY3RvciI6Ik50d0lpZVFFaG9Cb3FJRzFxT29yREE9PSIsImtleUlkIjoiT2pOQUJrL21Uam5kTGtWZlR1U1F0dz09In0=",
    //              "amount": {
    //                "value": "2.00",
    //                "currency": "RUB"
    //              },
    //              "confirmation": {
    //                "type": "redirect",
    //                "enforce": false,
    //                "return_url": "https://www.merchant-website.com/return_url"
    //              },
    //              "capture": false,
    //              "description": "Заказ №72"
    //            }
    //    }
    
}
