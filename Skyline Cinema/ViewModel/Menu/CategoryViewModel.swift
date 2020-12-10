//
//  CategoryViewModel.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 09.12.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation

protocol CategoryViewModelProtocol {
    var name: String {get}
    var items: [ItemViewModelProtocol] {get set}
}

class CategoryViewModel: CategoryViewModelProtocol {
    private var category: Category
    
    var name: String {
        return category.name
    }
    
    var items: [ItemViewModelProtocol]
    
    init(category: Category) {
        self.category = category
        self.items = [ItemViewModelProtocol]()
        
        category.items.forEach {
            self.items.append(ItemViewModel(item: $0))
        }
    }
}
