/// Тип суммы на форме оплаты.
public enum AmountType: String, Decodable, Encodable {

    /// Cумма к списанию со счета покупателя
    case amount

    /// Cумма к перечислению в магазин (к получению).
    case netAmount
}
