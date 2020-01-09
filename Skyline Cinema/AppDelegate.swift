//
//  AppDelegate.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 10/06/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let itemsURL = "http://skylinecinema.ru/request/menu"
    var window: UIWindow?
    let realm = try! Realm()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // TODO: uncomment lines
        // TODO: delete mock
        // Alamofire.request(itemsURL, method: .get).responseJSON { (response) in
        // if response.result.isSuccess {
        try! self.realm.write {
            // MARK: check for older items in Realm
            var itemsOldList : Results<Item>
            itemsOldList = realm.objects(Item.self)
            if itemsOldList.count != 0 {
                // delete older items
//                realm.delete(itemsOldList)
                realm.deleteAll()
            }
            
            // print("SUCCESS: \(response.result)" )
            // let jsonResponse: JSON = JSON(response.result.value!)
            // MARK: parse JSON from server
            var json: JSON?
            if let dataFromString = self.mockJSON().data(using: .utf8, allowLossyConversion: false) {
                json = try JSON(data: dataFromString)
            }
            let jsonResponse: JSON = json!
            print("JSON MENU RESPONSE: \(jsonResponse)")
            let itemsJSON = jsonResponse["itemsResponse"]
            var itemsFromJSON = [Item]()
            // parse items from JSON
            for itemResponse in itemsJSON.arrayValue {
                let newItem = Item()
                newItem.title = itemResponse["title"].stringValue
                newItem.descript = itemResponse["description"].stringValue
                newItem.price = Double(itemResponse["price"].stringValue) ?? 0
                itemsFromJSON.append(newItem)
            }
            
            if(itemsFromJSON.count == 0) {
                print("ERROR: No items data received")
            }
            else {
                // MARK: save items to Realm
                realm.add(itemsFromJSON)
            }
            // }
            // }
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func mockJSON() -> String {
        return "{\"itemsResponse\":[{\"id\":1,\"title\":\"Попкорн Большой Соленый\",\"description\":\"Охуенный Охуеннее Охуенного попкорн\",\"price\":350},{\"id\":2,\"title\":\"Попкорн Большой Сладкий\",\"description\":\"Охуенный Охуеннее Охуенного попкорн\",\"price\":350},{\"id\":15,\"title\":\"Пепси 0,5\",\"description\":\"Пепси же\",\"price\":100}]}"
    }
}

