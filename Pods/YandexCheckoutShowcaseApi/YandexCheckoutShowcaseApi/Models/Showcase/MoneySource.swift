/// Доступные методов оплаты.
public enum MoneySource: String, Decodable, Encodable {

    /// Со счета в Яндекс.Деньгах.
    case wallet

    /// Привязанные к счету банковские карты.
    case cards

    /// Банковская карта.
    case paymentCard = "payment-card"

    /// Наличные.
    case cash
}
