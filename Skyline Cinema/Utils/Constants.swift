//
//  Constants.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 10.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation

enum Constants {
    public static let networkActive: Bool = false
    
    public static let menuMap: [String: Int] = [
        "Попкорн": 1,
        "Напитки": 2,
        "Чипсы": 3,
        "Шоколад": 4,
        "Кальяны": 5
    ]
    public static let propLicensePlateNumber = "LicensePlateNumber"
    public static let propCity = "City"
    public static let propName = "Name"
    // MARK: MenuViewController

    // MARK: CartViewController
    public static let totalAmount = "Сумма заказа: "
    // MARK: OrderCompleteViewController
    public static let orderRequest = "orderRequest"
    public static let licensePlateNumber = "licensePlateNumber"
    public static let city = "city"
    public static let date = "date"
    public static let itemIds = "itemIds"
    public static let bonApetit = "Приятного аппетита!"
    public static let bonApetitError = "Уупс, что-то пошлон не так."
    
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
    
    // MARK: BuyTicketCompleteViewController
    public static let kinopoiskId = "kinopoiskId"
    
    // MARK:
    public static let ticketToCar = "Билет преобратается на автомобиль. Количество человек в машине не ограничено."
    public static let ticketToCarError = "Уупс, что-то пошлон не так."
    
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
    
    public static let personalDataWarning = "Администрация Автокинотеатра гарантирует полную конфиденциальность персональных данных пользователей, обрабатываемых при предоставлении услуги покупки билета, заказа еды и напитков за исключением случаев, прямо предусмотренных действующим законодательством РФ."

    public static let EventSuccessfullyAddedToСalendarWarning = "Событие о киносеансе добавлено в ваш календарь."

}
