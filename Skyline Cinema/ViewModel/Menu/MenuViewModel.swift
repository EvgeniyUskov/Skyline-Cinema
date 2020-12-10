//
//  MenuViewModel.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 09.12.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation

protocol MenuViewModelProtocol{
    var categoriesViewModel: [CategoryViewModelProtocol] {get set}
    
    func getItem(forIndexPath indexPath: IndexPath) -> Item
//    func viewModel(forCategory category: Category) -> CategoryViewModelProtocol
}

class MenuViewModel: MenuViewModelProtocol {
    var categoriesViewModel: [CategoryViewModelProtocol]
    
    init(categories: [Category]) {
        self.categoriesViewModel = [CategoryViewModel]()
        categories.forEach {
            categoriesViewModel.append(CategoryViewModel(category: $0))
        }
        sortCategories()
    }
    
    private func sortCategories() {
        categoriesViewModel = categoriesViewModel.sorted(by: {
            return Constants.menuMap[$0.name]! < Constants.menuMap[$1.name]!
        })
    }
    
    func getItem(forIndexPath indexPath: IndexPath) -> Item {
        return categoriesViewModel[indexPath.section].items[indexPath.row].getItem()
    }
    
    //    func viewModel(forCategory category: Category) -> CategoryViewModelProtocol {
    //        return CategoryViewModel(category: category)
    //    }
}
