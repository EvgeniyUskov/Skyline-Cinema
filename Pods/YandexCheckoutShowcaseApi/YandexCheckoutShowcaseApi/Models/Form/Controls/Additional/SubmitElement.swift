/// Элемент отправки формы.
public struct SubmitElement: Decodable, Encodable {

    /// Наименование товарного предложения или варианта оплаты.
    public let label: String

    /// Стоимость товара при покупки у этого поставщика или при этом варианте оплаты.
    public let amount: Double

    /// Трёхсимвольный буквенный код валюты по стандарту ISO-4217.
    public let currency: String

    // TODO: TMP
    /**
        Служебные поля формы.
        Эти поля дополняют и переопределяют поля блока hidden_fields формы,
        указывая серверу какой вариант оплаты выбран покупателем.
     */
    public let hiddenFields: [String: String]

    /// Дополнительные атрибуты, которые относятся к конкретному товарному предложению.
    public let items: [SubmitElementItem]

    public init(label: String,
                amount: Double,
                currency: String,
                hiddenFields: [String: String],
                items: [SubmitElementItem]) {
        self.label = label
        self.amount = amount
        self.currency = currency
        self.hiddenFields = hiddenFields
        self.items = items
    }

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let label = try container.decode(String.self, forKey: .label)
        let amount = try container.decode(Double.self, forKey: .amount)
        let currency = try container.decodeIfPresent(String.self, forKey: .currency) ?? "RUB"
        let hiddenFields = try container.decode([String: String].self, forKey: .hiddenFields)

        var items: [SubmitElementItem] = []

        if var itemsContainer = try? container.nestedUnkeyedContainer(forKey: .items) {
            items.reserveCapacity(itemsContainer.count ?? 0)
            while itemsContainer.isAtEnd != true {
                let item = try itemsContainer.decode(SubmitElementItem.self)
                items.append(item)
            }
        }

        self.init(label: label, amount: amount, currency: currency, hiddenFields: hiddenFields, items: items)
    }

    // MARK: - Encodable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(label, forKey: .label)
        try container.encode(amount, forKey: .amount)
        try container.encode(currency, forKey: .currency)
        try container.encode(hiddenFields, forKey: .hiddenFields)

        if items.isEmpty == false {
            var itemsContainer = container.nestedUnkeyedContainer(forKey: .items)
            for item in items {
                try itemsContainer.encode(item)
            }
        }
    }

    private enum CodingKeys: String, CodingKey {
        case label
        case amount
        case currency
        case hiddenFields = "hidden_fields"
        case items
    }
}
