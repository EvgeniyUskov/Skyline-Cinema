import Foundation

/// Контейнер содержит ссылку на изображение которое следует отобразить на форме.
public struct VideoContainer: Container {

    /// Container
    public let type: FormType = .video
    public let name: String?
    public let display: ContainerDisplayType

    /// Абсолютный URL изображения.
    public let src: URL

    public let poster: URL

    public init(name: String?,
                display: ContainerDisplayType,
                src: URL,
                poster: URL) {
        self.name = name
        self.display = display
        self.src = src
        self.poster = poster
    }

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard case .video = try container.decode(FormType.self, forKey: .type) else {
            throw DecodingError.invalidType
        }

        let name = try container.decodeIfPresent(String.self, forKey: .name)
        let display = try container.decodeIfPresent(ContainerDisplayType.self, forKey: .display) ?? .mandatory
        let src = try container.decode(URL.self, forKey: .src)
        let poster = try container.decode(URL.self, forKey: .poster)

        self.init(name: name, display: display, src: src, poster: poster)
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
        try container.encode(poster, forKey: .poster)

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
        case poster
    }
}
