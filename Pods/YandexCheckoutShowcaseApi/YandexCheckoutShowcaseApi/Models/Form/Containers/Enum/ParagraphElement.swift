public enum ParagraphElement: Decodable, Encodable {

    /// Cтрока текста
    case text(String)

    /// Гиперссылка
    case hyperlink(Hyperlink)

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let text = try? container.decode(String.self) {
            self = .text(text)
        } else if let hyperlink = try? container.decode(Hyperlink.self) {
            self = .hyperlink(hyperlink)
        } else {
            throw DecodingError.incorrectElement
        }
    }

    enum DecodingError: Error {
        case incorrectElement
    }

    // MARK: - Encodable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case let .hyperlink(hyperlink):
            try container.encode(hyperlink)
        case let .text(text):
            try container.encode(text)
        }
    }
}
