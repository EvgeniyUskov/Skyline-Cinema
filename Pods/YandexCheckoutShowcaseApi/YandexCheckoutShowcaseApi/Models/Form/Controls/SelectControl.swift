import Foundation

/// Контрол, предназначенный для выбора одного значения из списка.
public struct SelectControl: Control {

    /// ControlProtocol
    public let type: FormType = .select
    public let name: String
    public let value: String?
    public let autofillValue: Autofill?
    public let hint: String?
    public let label: String?
    public let alert: String?
    public let required: Bool
    public let readonly: Bool
    public let options: [SelectOption]
    public let style: SelectControlStyle?
    public let placeholder: SelectControlPlaceholder

    public init(name: String,
                value: String?,
                autofillValue: Autofill?,
                hint: String?,
                label: String?,
                alert: String?,
                required: Bool,
                readonly: Bool,
                options: [SelectOption],
                style: SelectControlStyle?,
                placeholder: SelectControlPlaceholder?) {
        self.name = name
        self.value = value
        self.autofillValue = autofillValue
        self.hint = hint
        self.label = label
        self.alert = alert
        self.required = required
        self.readonly = readonly
        self.options = options
        self.style = style
        self.placeholder = placeholder ?? .default
    }

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard case .select = try container.decode(FormType.self, forKey: .type) else {
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

        let style = try container.decodeIfPresent(SelectControlStyle.self, forKey: .style)
        let placeholder = try container.decodeIfPresent(SelectControlPlaceholder.self, forKey: .placeholder)

        let options = try container.decodeIfPresent([SelectOption].self, forKey: .options) ?? []

        self.init(name: name,
                  value: value,
                  autofillValue: autofillValue,
                  hint: hint,
                  label: label,
                  alert: alert,
                  required: required,
                  readonly: readonly,
                  options: options,
                  style: style,
                  placeholder: placeholder)
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
        try container.encodeIfPresent(style, forKey: .style)
        if case let .text(text) = placeholder {
            try container.encode(text, forKey: .placeholder)
        }
        if options.isEmpty == false {
            try container.encode(options, forKey: .options)
        }
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
        case options
        case style
        case placeholder
    }
}
