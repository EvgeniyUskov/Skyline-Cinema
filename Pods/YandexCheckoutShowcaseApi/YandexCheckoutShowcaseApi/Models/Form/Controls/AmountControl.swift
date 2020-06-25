import Foundation

/// Однострочное поле ввода суммы, расширяет тип number.
public struct AmountControl: Control {

    /// ControlProtocol
    public let type: FormType = .amount
    public let name: String
    public let value: String?
    public let autofillValue: Autofill?
    public let hint: String?
    public let label: String?
    public let alert: String?
    public let required: Bool
    public let readonly: Bool

    /// Минимально допустимое значение.
    public let min: Double

    /// Максимально допустимое значение.
    public let max: Double?

    /// Кратность значения суммы.
    public let step: Double

    /// Трёхсимвольный буквенный код валюты по стандарту ISO-4217.
    public let currency: String

    /// Информация о комиссии с покупателя.
    public let fee: Fee?

    public init(name: String,
                value: String?,
                autofillValue: Autofill?,
                hint: String?,
                label: String?,
                alert: String?,
                required: Bool,
                readonly: Bool,
                min: Double,
                max: Double?,
                step: Double,
                currency: String,
                fee: Fee?) {
        self.name = name
        self.value = value
        self.autofillValue = autofillValue
        self.hint = hint
        self.label = label
        self.alert = alert
        self.required = required
        self.readonly = readonly
        self.min = min
        self.max = max
        self.step = step
        self.currency = currency
        self.fee = fee
    }

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard case .amount = try container.decode(FormType.self, forKey: .type) else {
            throw DecodingError.invalidType
        }

        let name = try container.decode(String.self, forKey: .name)
        let value = try container.decodeIfPresent(String.self, forKey: .value)
        let autofillValue = try container.decodeIfPresent(Autofill.self, forKey: .autofill)
        let hint = try container.decodeIfPresent(String.self, forKey: .hint)
        let label = try container.decodeIfPresent(String.self, forKey: .label)
        let alert = try container.decodeIfPresent(String.self, forKey: .alert)
        let required = try container.decode(Bool.self, forKey: .required)
        let readonly = try container.decode(Bool.self, forKey: .readonly)
        let min = try container.decodeIfPresent(Double.self, forKey: .min) ?? 0.01
        let max = try container.decodeIfPresent(Double.self, forKey: .max)
        let step = try container.decodeIfPresent(Double.self, forKey: .step) ?? 0.01
        let currency = try container.decodeIfPresent(String.self, forKey: .currency) ?? "RUB"
        let fee = try container.decodeIfPresent(Fee.self, forKey: .fee)

        self.init(name: name,
                  value: value,
                  autofillValue: autofillValue,
                  hint: hint,
                  label: label,
                  alert: alert,
                  required: required,
                  readonly: readonly,
                  min: min,
                  max: max,
                  step: step,
                  currency: currency,
                  fee: fee)
    }

    enum DecodingError: Error {
        case invalidType
    }

    // MARK: - Encodable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(type, forKey: .type)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(value, forKey: .value)
        try container.encodeIfPresent(autofillValue, forKey: .autofill)
        try container.encodeIfPresent(hint, forKey: .hint)
        try container.encodeIfPresent(label, forKey: .label)
        try container.encodeIfPresent(alert, forKey: .alert)
        try container.encode(required, forKey: .required)
        try container.encode(readonly, forKey: .readonly)

        if min != 0.01 {
            try container.encode(min, forKey: .min)
        }

        try container.encodeIfPresent(max, forKey: .max)

        if step != 0.01 {
            try container.encode(step, forKey: .step)
        }

        if currency != "RUB" {
            try container.encode(currency, forKey: .currency)
        }

        try container.encodeIfPresent(fee, forKey: .fee)
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case name
        case value
        case autofill = "value_autofill"
        case hint
        case label
        case alert
        case required
        case readonly
        case min
        case max
        case step
        case currency
        case fee
    }
}
