import YandexMoneyCoreApi

public struct PersonifyForm: IdentificationApiResponse, JsonApiResponse, Decodable, Encodable {

    /// Наименование формы.
    public let title: String

    /// Описание формы, которую необходимо отобразить.
    public let form: [ContainerElement]

    public init(title: String,
                form: [ContainerElement]) {

        self.title = title
        self.form = form
    }

    public struct Method: Decodable, Encodable {

        public let merchantToken: String
        public let language: String

        public init(merchantToken: String,
                    language: String = "ru") {
            self.merchantToken = merchantToken
            self.language = language
        }

        // MARK: - Decodable

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            let language = try container.decode(String.self, forKey: .language)

            self.init(merchantToken: "", language: language)
        }

        // MARK: - Encodable

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(language, forKey: .language)
        }

        private enum CodingKeys: String, CodingKey {
            case language = "lang"
        }
    }

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let title = try container.decode(String.self, forKey: .title)
        let form = try container.decode([ContainerElement].self, forKey: .form)

        self.init(title: title, form: form)
    }

    // MARK: - Encodable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(title, forKey: .title)
        try container.encode(form, forKey: .form)
    }

    private enum CodingKeys: String, CodingKey {
        case form
        case title
    }
}

// MARK: - ApiMethod

extension PersonifyForm.Method: ApiMethod {

    public typealias Response = PersonifyForm

    public var hostProviderKey: String {
        return Constants.personifyApiMethodsKey
    }

    public var httpMethod: HTTPMethod {
        return .get
    }

    public var parametersEncoding: ParametersEncoding {
        return QueryParametersEncoder()
    }

    public var headers: Headers {
        let headers: [String: String] = [
            HeaderConstants.merchantAuthorization: HeaderConstants.basicPrefix + " \(merchantToken)",
        ]
        return Headers(headers)
    }

    public func urlInfo(from hostProvider: HostProvider) throws -> URLInfo {
        return .components(host: try hostProvider.host(for: hostProviderKey),
                           path: "/api/identification/v2/personify-form")
    }
}
