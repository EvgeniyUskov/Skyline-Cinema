//
//  Constants.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 10.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation

enum Routes {
    
    static let skylineCinemaItemsURL = "https://skylinecinema.ru/menu"
    static let skylineCinemaMoviesURL = "https://skylinecinema.ru/movies"
    static let skylineCinemaMembershipURL = "https://skylinecinema.ru/membership"
    static let skylineCinemaAddressRequestURL = "https://skylinecinema.ru/addresses"
    
    static let skylineCinemaOrderRequestURL = "https://skylinecinema.ru/order"
    static let skylineCinemaTicketRequestURL = "https://skylinecinema.ru/ticket"
    static let skyLineCinemaSuccessPaymentURL = "https://skylinecinema.ru/success"
    
    static let vkURL = "https://vk.com/skyline.cinema"
    static let igURL = "https://www.instagram.com/skyline.cinema/"
    static let fbURL = "https://www.facebook.com/Автокинотеатр-SkylineCinema-1708504372569940"
    static let tlgURL = "https://t.me/skylinecinema_bot"
    static let safariURL = "http://skylinecinema.ru"
    
    static let kinopoiskRatesURL = "https://rating.kinopoisk.ru/"
    static let kinopoiskRatesURLXMLExtension = ".xml"
    static let kinopoiskMovieDetailsURL = "https://www.kinopoisk.ru/film/"
    
    static let wikiURL = "https://ru.wikipedia.org/w/api.php"
    
    static let buyTicketURL = "https://money.yandex.ru/new/transfer/a2w"
    
    static let yandexPaymentURL = "https://payment.yandex.net/api/v3/payments"
}

enum Constants {
    // TODO: change addresses
//    public static let shopId = "53097" // боевой shopId
    public static let shopId = "676332" // тестовый shopId
//    public static let shopName = "Skyline Cinema" // боевой shopName
    public static let shopName = "test_(53097) ИП Афонасов Никита Алексеевич" // тестовый shopName
    
    public static let mobileSDKApiKey = "" // Ключ мобильного SDK iOS
    
    public static let propYandexApiKey = "Yandex.kassa API key"
    
    public static let isNetworkActive: Bool = false
    
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
