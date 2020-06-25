/// Тип комиссии с покупателя
public enum FeeType: String, Decodable, Encodable {

    /// Комиссия описывается стандартной формулой.
    case std

    /**
        Комиссия со сложной формулой или расчет комиссии на стороне магазина, комиссия будет рассчитана при платеже.
        Необходимо уведомить покупателя о факте наличия комиссии.
     */
    case custom
}