/// UI контрол инициирующий отправку формы на сервер.
public struct SubmitControl: Control {

    /// ControlProtocol
    public let type: FormType = .submit
    public let name: String = ""
    public let value: String?
    public let autofillValue: Autofill?
    public let hint: String?
    public let label: String?
    public let alert: String?
    public let required: Bool
    public let readonly: Bool

    public let items: [SubmitElement]

    public init(value: String?,
                autofillValue: Autofill?,
                hint: String?,
                label: String?,
                alert: String?,
                required: Bool,
                readonly: Bool,
                items: [SubmitElement]) {
        self.value = value
        self.autofillValue = autofillValue
        self.hint = hint
        self.label = label
        self.alert = alert
        self.required = required
        self.readonly = readonly
        self.items = items
    }

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard case .submit = try container.decode(FormType.self, forKey: .type) else {
            throw DecodingError.invalidType
        }

        let value = try container.decodeIfPresent(String.self, forKey: .value)
        let autofillValue = try container.decodeIfPresent(Autofill.self, forKey: .autofill)
        let hint = try container.decodeIfPresent(String.self, forKey: .hint)
        let label = try container.decodeIfPresent(String.self, forKey: .label)
        let alert = try container.decodeIfPresent(String.self, forKey: .alert)
        let required = try container.decodeIfPresent(Bool.self, forKey: .required) ?? true
        let readonly = try container.decodeIfPresent(Bool.self, forKey: .readonly) ?? true

        let items = try container.decodeIfPresent([SubmitElement].self, forKey: .items) ?? []

        self.init(value: value,
                  autofillValue: autofillValue,
                  hint: hint,
                  label: label,
                  alert: alert,
                  required: required,
                  readonly: readonly,
                  items: items)
    }

    enum DecodingError: Error {
        case invalidType
    }

    // MARK: - Encodable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(value, forKey: .value)
        try container.encodeIfPresent(autofillValue, forKey: .autofill)
        try container.encodeIfPresent(hint, forKey: .hint)
        try container.encodeIfPresent(label, forKey: .label)
        try container.encodeIfPresent(alert, forKey: .alert)
        try container.encode(required, forKey: .required)
        try container.encode(readonly, forKey: .readonly)

        if items.isEmpty == false {
            try container.encode(items, forKey: .items)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case value
        case autofill = "value_autofill"
        case hint
        case label
        case alert
        case required
        case readonly
        case items
    }
}
