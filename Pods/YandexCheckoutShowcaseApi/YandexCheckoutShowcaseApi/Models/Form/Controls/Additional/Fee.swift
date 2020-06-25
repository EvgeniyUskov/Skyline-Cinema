import Foundation

/// Комиссии с покупателя.
public struct Fee: Decodable, Encodable {

    /// Тип комиссии.
    public let type: FeeType

    /// Коэффициент от суммы к перечислению в магазин (netAmount).
    public let a: Decimal

    /// Фиксированная сумма комиссии за операцию в единицах currency.
    public let b: Decimal

    /// Минимальная комиссия за операцию в единицах currency.
    public let c: Decimal

    /// Максимальная комиссия за операцию в единицах currency.
    public let d: Decimal?

    /// Тип суммы на форме оплаты.
    public let amountType: AmountType

    public init(type: FeeType,
                a: Decimal,
                b: Decimal,
                c: Decimal,
                d: Decimal?,
                amountType: AmountType) {
        self.type = type
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.amountType = amountType
    }

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let type = try container.decodeIfPresent(FeeType.self, forKey: .type) ?? .std
        let a = try container.decodeIfPresent(Decimal.self, forKey: .a) ?? 0
        let b = try container.decodeIfPresent(Decimal.self, forKey: .b) ?? 0
        let c = try container.decodeIfPresent(Decimal.self, forKey: .c) ?? 0
        let d = try container.decodeIfPresent(Decimal.self, forKey: .d)
        let amountType = try container.decodeIfPresent(AmountType.self, forKey: .amountType) ?? .amount

        self.init(type: type, a: a, b: b, c: c, d: d, amountType: amountType)
    }

    // MARK: - Encodable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch type {
        case .std:
            break
        default:
            try container.encode(type, forKey: .type)
        }

        if a != 0 {
            try container.encode(a, forKey: .a)
        }

        if b != 0 {
            try container.encode(b, forKey: .b)
        }

        if c != 0 {
            try container.encode(c, forKey: .c)
        }

        try container.encodeIfPresent(d, forKey: .d)

        switch amountType {
        case .amount:
            break
        default:
            try container.encode(amountType, forKey: .amountType)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case a
        case b
        case c
        case d
        case amountType = "amount_type"
    }
}
