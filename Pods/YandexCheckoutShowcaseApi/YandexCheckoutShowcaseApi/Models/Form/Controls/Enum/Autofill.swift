import Foundation

/**
 *  Макросы автоподстановки предназначены для предварительного заполнения значения поля формы
 *  определённым значением на стороне клиента.
 */
public enum Autofill: String, Decodable, Encodable {

    /// Подставляет номер счета пользователя Яндекс.Денег, если он известен.
    case accountkey = "currentuser_accountkey"

    /// Подставляет в поле типа month значение yyyy-mm следующего месяца за текущим календарным месяцем.
    case nextMonth = "calendar_next_month"

    /// Подставляет login@yandex.ru для авторизованного пользователя, если он известен.
    case email = "currentuser_email"
}
