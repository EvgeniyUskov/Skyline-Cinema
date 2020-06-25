import Foundation
import YandexMoneyCoreApi

/// Модель формы оплаты.
public struct Showcase: JsonApiResponse, Decodable, Encodable {

    /// Наименование оплачиваемого товара.
    public let title: String

    /// Служебные поля формы
    /// Клиент должен прозрачно передать этот набор полей при отправке данных формы на сервер.
    public let hiddenFields: [String: String]

    /// Список доступных методов оплаты.
    public let moneySource: [MoneySource]

    /// Описание формы, которую необходимо отобразить покупателю.
    public let form: [ContainerElement]

    /// Дополнительный блок.
    public let aside: GroupContainer?

    /// Дополнительный блок.
    public let footer: GroupContainer?

    /// Адрес отправки введеных данных.
    public let processUrl: URL

    public init(title: String,
                hiddenFields: [String: String],
                moneySource: [MoneySource],
                form: [ContainerElement],
                aside: GroupContainer? = nil,
                footer: GroupContainer? = nil,
                processUrl: URL) {

        self.title = title
        self.hiddenFields = hiddenFields
        self.moneySource = moneySource
        self.form = form
        self.aside = aside
        self.footer = footer
        self.processUrl = processUrl
    }

    public struct Method: Encodable, Decodable {

        public let pattern: Int
        public let language: String

        public init(pattern: Int,
                    language: String = "ru") {
            self.pattern = pattern
            self.language = language
        }

        // MARK: - Decodable

        public init(from decoder: Decoder) throws {
            self.init(pattern: 0, language: "")
        }

        // MARK: - Encodable

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            let value: [String: String] = [:]
            try container.encode(value)
        }
    }

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let title = try container.decode(String.self, forKey: .title)
        let hiddenFields = try container.decodeIfPresent([String: String].self, forKey: .hiddenFields) ?? [:]
        let moneySource = try container.decodeIfPresent([MoneySource].self, forKey: .moneySource) ?? []
        let form = try container.decodeIfPresent([ContainerElement].self, forKey: .form) ?? []

        let aside = try container.decodeIfPresent(GroupContainer.self, forKey: .aside)
        let footer = try container.decodeIfPresent(GroupContainer.self, forKey: .footer)

        self.init(title: title,
                  hiddenFields: hiddenFields,
                  moneySource: moneySource,
                  form: form,
                  aside: aside,
                  footer: footer,
                  processUrl: URL(fileURLWithPath: "", isDirectory: false))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(title, forKey: .title)
        try container.encode(hiddenFields, forKey: .hiddenFields)
        try container.encode(moneySource, forKey: .moneySource)
        try container.encode(form, forKey: .form)
        try container.encodeIfPresent(aside, forKey: .aside)
        try container.encodeIfPresent(footer, forKey: .footer)
    }

    private enum CodingKeys: String, CodingKey {
        case title
        case hiddenFields = "hidden_fields"
        case moneySource = "money_source"
        case form
        case aside
        case footer
    }
}

// MARK: - ShowcaseApiResponse

extension Showcase: ShowcaseApiResponse {
    public static func makeResponse(response: HTTPURLResponse, data: Data) -> Showcase? {

        guard let location = response.allHeaderFields[HeaderConstants.location] as? String,
              let processUrl = URL(string: location),
              let data = try? JSONDecoder().decode(Showcase.self, from: data) else {
            return nil
        }

        return Showcase(title: data.title,
                        hiddenFields: data.hiddenFields,
                        moneySource: data.moneySource,
                        form: data.form,
                        aside: data.aside,
                        footer: data.footer,
                        processUrl: processUrl)
    }
}

// MARK: - ApiMethod

extension Showcase.Method: ApiMethod {

    public typealias Response = Showcase

    public var hostProviderKey: String {
        return Constants.showcaseApiMethodsKey
    }

    public var httpMethod: HTTPMethod {
        return .get
    }

    public var parametersEncoding: ParametersEncoding {
        return JsonParametersEncoder()
    }

    public var headers: Headers {
        let headers = [
            HeaderConstants.language: language,
        ]
        return Headers(headers)
    }

    public func urlInfo(from hostProvider: HostProvider) throws -> URLInfo {
        return .components(host: try hostProvider.host(for: hostProviderKey),
                           path: "/api/showcase/\(pattern)")
    }
}

private extension Showcase.Method {
    enum HeaderConstants {
        static let language = "Accept-Language"
    }
}
