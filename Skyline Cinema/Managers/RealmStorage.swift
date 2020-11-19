//
//  RealmStorage.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 18.11.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation
import RealmSwift

class RealmOrderStorage: OrderLocalStorage {
    
    let realm = try! Realm()
    
    func loadData() -> [Item] {
        menuList = Array(realm.objects(Item.self))
        createOrder()
    }
    
    func saveData(order: Order) {
        do{
            try realm.write {
                realm.add(order!)
            }
        } catch {
            print("error saving realm order\(error)")
        }
    }
    
}
