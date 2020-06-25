public struct Hyperlink: Form {

    public let type: FormType = .a

    /// HTTP(S)-гиперссылка
    public let href: String

    /// Текст ссылки, отображаемый покупателю
    public let label: String

    public init(href: String,
                label: String) {
        self.href = href
        self.label = label
    }

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard case .a = try container.decode(FormType.self, forKey: .type) else {
            throw DecodingError.invalidType
        }

        let href = try container.decode(String.self, forKey: .href)
        let label = try container.decode(String.self, forKey: .label)

        self.init(href: href, label: label)
    }

    // MARK: - Encodable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(href, forKey: .href)
        try container.encode(label, forKey: .label)
    }

    enum DecodingError: Error {
        case invalidType
    }

    enum CodingKeys: String, CodingKey {
        case type
        case href
        case label
    }
}
