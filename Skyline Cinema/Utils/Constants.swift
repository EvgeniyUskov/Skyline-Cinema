//
//  Constants.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 10.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation


struct Constants {
    static let shared = Constants()
    // MARK: MenuViewController
    // MARK: CartViewController
    public let totalAmount = "Сумма заказа: "
    // MARK: TitmeTableViewController
    // MARK: MovieDetailsViewController
    public let description = "description"
    public let imageURL = "imageURL"
    public let kpRate = "kpRate"
    public let imdbRate = "imdbRate"
    public let noRates = " - "
    // MARK: Kinopoisk parse html
    public let kinopoiskFilmSynopsys = "film-synopsys\" itemprop=\"description\">"
    public let kinopoiskFilmPoster = "popupBigImage"
    
    private init() { }
}
