/// Группа, содержащая список UI-контролов и/или вложенных контейнеров.
public struct GroupContainer: Container {

    /// Container
    public let type: FormType = .group
    public let name: String?
    public let display: ContainerDisplayType

    /// Список контролов и/или вложенных контейнеров.
    public let items: [ContainerElement]

    /// Заголовок группы (надпись над группой).
    public let label: String?

    /// Рекомендуемое расположение элементов внутри группы.
    public let layout: GroupLayout

    public init(name: String?,
                display: ContainerDisplayType,
                items: [ContainerElement],
                label: String?,
                layout: GroupLayout) {
        self.name = name
        self.display = display
        self.items = items
        self.label = label
        self.layout = layout
    }

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard case .group = try container.decode(FormType.self, forKey: .type) else {
            throw DecodingError.unsupportedElement
        }

        let name = try container.decodeIfPresent(String.self, forKey: .name)
        let display = try container.decodeIfPresent(ContainerDisplayType.self, forKey: .display) ?? .mandatory
        let label = try container.decodeIfPresent(String.self, forKey: .label)
        let layout = try container.decodeIfPresent(GroupLayout.self, forKey: .layout) ?? .vertical

        let items = try container.decodeIfPresent([ContainerElement].self, forKey: .items) ?? []

        self.init(name: name, display: display, items: items, label: label, layout: layout)
    }

    enum DecodingError: Error {
        case unsupportedElement
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

        switch layout {
        case .vertical:
            break
        default:
            try container.encode(layout, forKey: .layout)
        }

        if items.isEmpty == false {
            try container.encode(items, forKey: .items)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case type
        case display
        case items
        case label
        case layout
    }
}
