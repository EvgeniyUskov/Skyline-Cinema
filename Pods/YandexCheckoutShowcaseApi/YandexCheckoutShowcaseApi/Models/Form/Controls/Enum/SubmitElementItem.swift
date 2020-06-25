public enum SubmitElementItem: Decodable, Encodable {

    /// Параграф.
    case paragraph(ParagraphContainer)

    /// Гиперссылка.
    case hyperlink(Hyperlink)

    /// Маркированный спискок.
    case list(UnorderedListContainer)

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let list = try? container.decode(UnorderedListContainer.self) {
            self = .list(list)
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
        case let .list(list):
            try container.encode(list)
        case let .paragraph(paragraph):
            try container.encode(paragraph)
        }
    }
}
