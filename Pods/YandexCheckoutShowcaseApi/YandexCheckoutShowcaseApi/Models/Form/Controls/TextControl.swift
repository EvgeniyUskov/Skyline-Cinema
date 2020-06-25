import Foundation

/// Однострочное поле ввода текста.
public struct TextControl: Control {

    /// ControlProtocol
    public let type: FormType = .text
    public let name: String
    public let value: String?
    public let autofillValue: Autofill?
    public let hint: String?
    public let label: String?
    public let alert: String?
    public let required: Bool
    public let readonly: Bool

    /// Минимально допустимая длина строки.
    public let minLength: Int?

    /// Максимально допустимая длина строки.
    public let maxLength: Int?

    /// Регулярное выражение для проверки введенного покупателем значения.
    public let pattern: String?

    /// Рекомендуемый тип экранной клавиатуры для мобильных устройств.
    public let keyboardType: KeyboardType

    public init(name: String,
                value: String?,
                autofillValue: Autofill?,
                hint: String?,
                label: String?,
                alert: String?,
                required: Bool,
                readonly: Bool,
                minLength: Int?,
                maxLength: Int?,
                pattern: String?,
                keyboardType: KeyboardType) {
        self.name = name
        self.value = value
        self.autofillValue = autofillValue
        self.hint = hint
        self.label = label
        self.alert = alert
        self.required = required
        self.readonly = readonly
        self.minLength = minLength
        self.maxLength = maxLength
        self.pattern = pattern
        self.keyboardType = keyboardType
    }

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard case .text = try container.decode(FormType.self, forKey: .type) else {
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
        let minLength = try container.decodeIfPresent(Int.self, forKey: .minLength)
        let maxLength = try container.decodeIfPresent(Int.self, forKey: .maxLength)
        let pattern = try container.decodeIfPresent(String.self, forKey: .pattern)
        let keyboardType = try container.decodeIfPresent(KeyboardType.self, forKey: .keyboardType) ?? .text

        self.init(name: name,
                  value: value,
                  autofillValue: autofillValue,
                  hint: hint,
                  label: label,
                  alert: alert,
                  required: required,
                  readonly: readonly,
                  minLength: minLength,
                  maxLength: maxLength,
                  pattern: pattern,
                  keyboardType: keyboardType)
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
        try container.encodeIfPresent(minLength, forKey: .minLength)
        try container.encodeIfPresent(maxLength, forKey: .maxLength)
        try container.encodeIfPresent(pattern, forKey: .pattern)

        switch keyboardType {
        case .text:
            break
        default:
            try container.encode(keyboardType, forKey: .keyboardType)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case type
        case value
        case autofill = "value_autofill"
        case hint
        case label
        case alert
        case required
        case readonly
        case minLength = "minlength"
        case maxLength = "maxlength"
        case pattern
        case keyboardType = "keyboard_suggest"
    }
}
