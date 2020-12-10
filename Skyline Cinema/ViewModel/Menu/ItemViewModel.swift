//
//  ItemViewModel.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 09.12.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation

protocol ItemViewModelProtocol {
    var id: Int {get}
    var category: String {get}
    var title: String {get}
    var descript: String {get}
    var price: String {get}
    var checked: Bool {get set}
    
    func getItem() -> Item
}

class ItemViewModel: ItemViewModelProtocol {
    
    private var item: Item
    
    var id: Int {
        return item.id
    }
    var category: String {
        return item.category
    }
    var title: String {
        return item.title
    }
    var descript: String {
        return item.descript
    }
    var price: String {
        return String.priceFormatCeil(item.price)
    }
    var checked: Bool
    
    init(item: Item) {
        self.item = item
        checked = false
    }
    
    func getItem() -> Item {
        return item
    }
}
