/// Маркированный список блоков статического текста, может содержать гиперссылки.
public struct UnorderedListContainer: Container {

    /// Container
    public let type: FormType = .ul
    public let name: String?
    public let display: ContainerDisplayType

    /// Набор элементов списка.
    public let items: [ListElement]

    /// Заголовок блока (надпись над списком).
    public let label: String?

    public init(name: String?,
                display: ContainerDisplayType,
                items: [ListElement],
                label: String?) {
        self.name = name
        self.display = display
        self.items = items
        self.label = label
    }

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard case .ul = try container.decode(FormType.self, forKey: .type) else {
            throw DecodingError.invalidType
        }

        let name = try container.decodeIfPresent(String.self, forKey: .name)
        let display = try container.decodeIfPresent(ContainerDisplayType.self, forKey: .display) ?? .mandatory
        let label = try container.decodeIfPresent(String.self, forKey: .label)

        let items = try container.decodeIfPresent([ListElement].self, forKey: .items) ?? []

        self.init(name: name, display: display, items: items, label: label)
    }

    enum DecodingError: Error {
        case invalidType
    }

    // MARK: - Encodable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(label, forKey: .label)

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

    enum CodingKeys: String, CodingKey {
        case name
        case type
        case display
        case items
        case label
    }
}
