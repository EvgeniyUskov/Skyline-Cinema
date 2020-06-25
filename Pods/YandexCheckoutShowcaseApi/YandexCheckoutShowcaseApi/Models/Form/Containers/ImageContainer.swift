import Foundation

/// Контейнер содержит ссылку на изображение которое следует отобразить на форме.
public struct ImageContainer: Container {

    /// Container
    public let type: FormType = .img
    public let name: String?
    public let display: ContainerDisplayType

    /// Абсолютный URL изображения.
    public let src: URL

    public init(name: String?,
                display: ContainerDisplayType,
                src: URL) {
        self.name = name
        self.display = display
        self.src = src
    }

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard case .img = try container.decode(FormType.self, forKey: .type) else {
            throw DecodingError.invalidType
        }

        let name = try container.decodeIfPresent(String.self, forKey: .name)
        let display = try container.decodeIfPresent(ContainerDisplayType.self, forKey: .display) ?? .mandatory
        let src = try container.decode(URL.self, forKey: .src)

        self.init(name: name, display: display, src: src)
    }

    enum DecodingError: Error {
        case invalidType
    }

    // MARK: - Encodable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(src, forKey: .src)

        switch display {
        case .mandatory:
            break
        default:
            try container.encode(display, forKey: .display)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case type
        case display
        case src
    }
}
