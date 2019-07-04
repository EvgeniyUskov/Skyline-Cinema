//
//  ItemConstants.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 03/07/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import Foundation

class ItemConstants {
    let popcorn : [Int: String] = [
        1: "Big Salty Popcorn",
        2: "Medium Salty Popcorn",
        3: "Small Salty Popcorn",
        4: "Big Sweet Popcorn",
        5: "Medium Sweet Popcorn",
        6: "Small Sweet Popcorn",
        ]
    let pepsi: [Int: String] = [
        7: "Big Pepsi",
        8: "Medium Pepsi",
        9: "Small Pepsi",
    ]
    
    let tea: [Int: String] = [
        10: "Green Tea",
        11: "Black Tea",
    ]
    
    let coffee: [Int: String] = [
        12: "Coffee Latte",
        13: "Coffee Capuccino",
        14: "Coffe Americano",
    ]
    
    let chips: [Int: String] = [
        15: "Pringles",
        16: "Lays"
    ]
    func getPopcornList() -> [Item]{
        var itemList : [Item] = [Item]()
        for item in popcorn {
             itemList.append(Item(id: item.key, desc: item.value))
        }
        return itemList
    }
    
    func getPepsiList() -> [Item]{
        var itemList : [Item] = [Item]()
        for item in pepsi {
            itemList.append(Item(id: item.key, desc: item.value))
        }
        return itemList
    }
    
    func getTeaList() -> [Item]{
        var itemList : [Item] = [Item]()
        for item in tea {
            itemList.append(Item(id: item.key, desc: item.value))
        }
        return itemList
    }

    
    func getCoffeeList() -> [Item]{
        var itemList : [Item] = [Item]()
        for item in coffee {
            itemList.append(Item(id: item.key, desc: item.value))
        }
        return itemList
    }
    
    
    func getChipsList() -> [Item]{
        var itemList : [Item] = [Item]()
        for item in chips {
            itemList.append(Item(id: item.key, desc: item.value))
        }
        return itemList
    }
    
    func getItemById(id: Int) -> Item {
        var allItems : [Item] = getPopcornList()
        allItems.append(contentsOf: getChipsList())
        allItems.append(contentsOf: getPepsiList())
        allItems.append(contentsOf: getCoffeeList())
        allItems.append(contentsOf: getTeaList())
        for item in allItems {
            if item.id == id {
                return item
        }
        print("ERROR: ItemList has no item with id= \(id)")
    }
    
}
