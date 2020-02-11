//
//  Constants.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 10.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation

enum Constants {
        
    public static let propLicensePlateNumber = "LicensePlateNumber"
    public static let propCity = "City"
    public static let propName = "Name"
    // MARK: MenuViewController

    // MARK: CartViewController
    public static let totalAmount = "Сумма заказа: "
    // MARK: TitmeTableViewController

    // MARK: MovieDetailsViewController
    public static let description = "description"
    public static let imageURL = "imageURL"
    public static let kpRate = "kpRate"
    public static let imdbRate = "imdbRate"
    public static let noRates = " - "

    // MARK: Kinopoisk parse html
    public static let kinopoiskFilmSynopsys = "film-synopsys\" itemprop=\"description\">"
    public static let kinopoiskFilmPoster = "popupBigImage"

    // MARK: MembershipViewController
    public static let qrURL = "link"
    public static let endDate = "endDate"

    // MARK: InfoViewController
    public static let addressAddress = "address"
    public static let addressDescription = "description"
    public static let addressPhoneNumber = "phoneNumber"
    // MARK: Errors
    public static let errorLicensePlateNumber = "Введите корректный номер автомобиля \n"
    public static let errorName = "Введите ваше имя корректно \n"
    public static let errorCity = "Выберите ваш город \n"
    
}
