/**
    Заголовок, блок статического текста, может содержать гиперссылки.
    Представляет собой текст выделенный как заголовок.
*/
public struct HeaderContainer: Container {

    /// Container
    public let type: FormType = .header
    public let name: String?
    public let display: ContainerDisplayType

    /// Размер заголовка.
    public let rank: HeaderRank

    /// Набор элементов списка.
    public let items: [ParagraphElement]

    public init(name: String?,
                display: ContainerDisplayType,
                rank: HeaderRank,
                items: [ParagraphElement]) {
        self.name = name
        self.display = display
        self.rank = rank
        self.items = items
    }

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard case .header = try container.decode(FormType.self, forKey: .type) else {
            throw DecodingError.unsupportedElement
        }

        let name = try container.decodeIfPresent(String.self, forKey: .name)
        let display = try container.decodeIfPresent(ContainerDisplayType.self, forKey: .display) ?? .mandatory
        let rank = try container.decode(HeaderRank.self, forKey: .rank)

        let items = try container.decodeIfPresent([ParagraphElement].self, forKey: .items) ?? []

        self.init(name: name, display: display, rank: rank, items: items)
    }

    enum DecodingError: Error {
        case unsupportedElement
    }

    // MARK: - Encodable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(rank, forKey: .rank)

        switch display {
        case .mandatory:
            break
        default:
            try container.encode(display, forKey: .display)
        }

        if items.isEmpty == false {
            try container.encode(items, forKey: .items)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case type
        case display
        case rank
        case items
    }
}
