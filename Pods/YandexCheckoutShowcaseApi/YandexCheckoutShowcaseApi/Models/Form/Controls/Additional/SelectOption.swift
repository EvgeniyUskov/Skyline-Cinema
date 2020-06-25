/// Элемент для выбора.
public struct SelectOption: Decodable, Encodable {

    /// Выбранное значение, которое будет отправлено на сервер как значение этого поля формы.
    public let value: String

    /// Текст отображаемый покупателю в списке значений.
    public let label: String

    /**
        Список (группа) UI-контролов и/или контейнеров, которые становятся видимыми, если выбрать это значение.
        Может содержать другие вложенные select.
     */
    public let group: [ContainerElement]

    // MARK: - Decodable

    public init(value: String,
                label: String,
                group: [ContainerElement]) {
        self.value = value
        self.label = label
        self.group = group
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let value = try container.decode(String.self, forKey: .value)
        let label = try container.decode(String.self, forKey: .label)

        var group: [ContainerElement] = []

        if var groupContainer = try? container.nestedUnkeyedContainer(forKey: .group) {
            group.reserveCapacity(groupContainer.count ?? 0)

            while groupContainer.isAtEnd != true {
                let containerElement = try groupContainer.decode(ContainerElement.self)
                group.append(containerElement)
            }
        }

        self.init(value: value, label: label, group: group)
    }

    // MARK: - Encodable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encode(label, forKey: .label)

        if group.isEmpty == false {
            var groupContainer = container.nestedUnkeyedContainer(forKey: .group)
            for element in group {
                try groupContainer.encode(element)
            }
        }
    }

    private enum CodingKeys: String, CodingKey {
        case value
        case label
        case group
    }
}
