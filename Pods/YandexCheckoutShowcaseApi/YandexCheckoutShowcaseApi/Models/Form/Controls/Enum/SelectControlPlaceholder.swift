public enum SelectControlPlaceholder: Decodable, Encodable {
    case text(String)
    case `default`

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let text = try container.decode(String.self)
        self = .text(text)
    }

    // MARK: - Encodable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .text(text):
            try container.encode(text)
        case .default:
            throw EncodingError.couldNotEncodeDefaultPlaceholder
        }
    }

    enum EncodingError: Error {
        case couldNotEncodeDefaultPlaceholder
    }
}
