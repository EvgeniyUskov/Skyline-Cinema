public enum ListElement: Decodable, Encodable {

    /// Cтрока текста
    case text(String)

    /// Гиперссылка
    case hyperlink(Hyperlink)

    /// Вложенный параграф
    case paragraph(ParagraphContainer)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let text = try? container.decode(String.self) {
            self = .text(text)
        } else if let hyperlink = try? container.decode(Hyperlink.self) {
            self = .hyperlink(hyperlink)
        } else if let paragraph = try? container.decode(ParagraphContainer.self) {
            self = .paragraph(paragraph)
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
        case let .paragraph(paragraph):
            try container.encode(paragraph)
        }
    }
}
