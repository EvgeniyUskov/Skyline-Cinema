import YandexMoneyCoreApi

public struct PersonifyRequest: IdentificationApiResponse, JsonApiResponse, Decodable, Encodable {

    /// Идентификатор запроса на прохождение УИ.
    public let requestId: String

    /// Статус процесса прохождения УИ.
    public let status: Status

    public init(requestId: String, status: Status) {
        self.requestId = requestId
        self.status = status
    }

    public struct PostMethod: Decodable, Encodable {

        public let passportToken: String
        public let merchantToken: String
        public let fields: [String: String]

        public init(passportToken: String,
                    merchantToken: String,
                    fields: [String: String]) {
            self.passportToken = passportToken
            self.merchantToken = merchantToken
            self.fields = fields
        }

        // MARK: - Decodable

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            let fields = try container.decode([String: String].self, forKey: .fields)

            self.init(passportToken: "", merchantToken: "", fields: fields)
        }

        // MARK: - Encodable

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(fields, forKey: .fields)
        }

        private enum CodingKeys: String, CodingKey {
            case fields
        }
    }

    public struct GetMethod: Decodable, Encodable {

        public let passportToken: String
        public let merchantToken: String
        public let requestId: String

        public init(passportToken: String,
                    merchantToken: String,
                    requestId: String) {
            self.passportToken = passportToken
            self.merchantToken = merchantToken
            self.requestId = requestId
        }

        // MARK: - Decodable

        public init(from decoder: Decoder) throws {
            _ = try decoder.singleValueContainer()

            self.init(passportToken: "", merchantToken: "", requestId: "")
        }

        // MARK: - Encodable

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            let value: [String: String] = [:]

            try container.encode(value)
        }
    }

    public enum Status: String, Decodable, Encodable {
        case pending = "Pending"
        case succeeded = "Succeeded"
        case failed = "Failed"
    }
}

// MARK: - ApiMethod
extension PersonifyRequest.PostMethod: ApiMethod {

    public typealias Response = PersonifyRequest

    public var hostProviderKey: String {
        return Constants.personifyApiMethodsKey
    }

    public var httpMethod: HTTPMethod {
        return .post
    }

    public var parametersEncoding: ParametersEncoding {
        return JsonParametersEncoder()
    }

    public var headers: Headers {
        let headers = [
            HeaderConstants.passportAuthorization: HeaderConstants.bearerPrefix + " \(passportToken)",
            HeaderConstants.merchantAuthorization: HeaderConstants.basicPrefix + " \(merchantToken)",
        ]
        return Headers(headers)
    }

    public func urlInfo(from hostProvider: HostProvider) throws -> URLInfo {
        return .components(host: try hostProvider.host(for: hostProviderKey),
                           path: "/api/identification/v2/personify-request")
    }
}

extension PersonifyRequest.GetMethod: ApiMethod {

    public typealias Response = PersonifyRequest

    public var hostProviderKey: String {
        return Constants.personifyApiMethodsKey
    }

    public var httpMethod: HTTPMethod {
        return .get
    }

    public var parametersEncoding: ParametersEncoding {
        return JsonParametersEncoder()
    }

    public var headers: Headers {
        let headers = [
            HeaderConstants.passportAuthorization: HeaderConstants.bearerPrefix + " \(passportToken)",
            HeaderConstants.merchantAuthorization: HeaderConstants.basicPrefix + " \(merchantToken)",
        ]
        return Headers(headers)
    }

    public func urlInfo(from hostProvider: HostProvider) throws -> URLInfo {
        return .components(host: try hostProvider.host(for: hostProviderKey),
                           path: "/api/identification/v2/personify-request/\(requestId)")
    }
}
