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
import YandexCheckoutPayments
import YandexCheckoutPaymentsApi

struct NetworkManager {
    var defaults = UserDefaults.standard
    
    let skylineCinemaItemsURL = "https://skylinecinema.ru/menu"
    let skylineCinemaMoviesURL = "https://skylinecinema.ru/movies"
    let skylineCinemaMembershipURL = "https://skylinecinema.ru/membership"
    let skylineCinemaAddressRequestURL = "https://skylinecinema.ru/addresses"
    
    let skylineCinemaOrderRequestURL = "https://skylinecinema.ru/order"
    let skylineCinemaTicketRequestURL = "https://skylinecinema.ru/ticket"
    let skyLineCinemaSuccessPaymentURL = "https://skylinecinema.ru/success"
    
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
    
    let yandexPaymentURL = "https://payment.yandex.net/api/v3/payments"
    
    
    let realm = try! Realm()
    let jsonManager = JSONManager()
    
    func getItems() -> [Category]{
        var groupsOfItems = [Category]()
        do{
            try realm.write {
                let olderItems = realm.objects(Item.self)
                realm.delete(olderItems)
                if Constants.isNetworkActive {
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
        if Constants.isNetworkActive {
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
            if Constants.isNetworkActive {
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
    
    func createPayment(paymentToken: Tokens, amount: Amount, description: String, completion: @escaping (Payment) -> Void) {
        let idempotenceKey = UUID()
        
        let headers : [String: Any] = [
            "Idempotence-Key" : idempotenceKey
        ]
        
        struct PaymentMethodData : Encodable {
            var type: String
        }
        let paymentMethodData = PaymentMethodData(type: "bank_card")
        
        struct Confirmation : Encodable {
            var type: String
            var enforce: Bool
            var returnUrl: String
        }
        let confirmation = Confirmation(type: "redirect",
                                        enforce: false,
                                        returnUrl: self.skyLineCinemaSuccessPaymentURL)
        
        let params : [String: Any] = [
            "payment_token": paymentToken,
            "amount": amount,
            "payment_method_data": paymentMethodData,
            "confirmation": confirmation,
            "capture": true,
            "description": description
        ]
        let cred = URLCredential(user: Constants.shopId , password: Constants.mobileSDKApiKey, persistence: .forSession)
        Alamofire.request(yandexPaymentURL, method: .post, parameters: params, headers: headers as! HTTPHeaders)
            .authenticate(usingCredential: cred)
            .responseJSON {
            (response) in
            
            let payment = self.jsonManager.parsePaymentJSON(response: response)
            completion(payment)
            
        }
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
        


    }
    
}
