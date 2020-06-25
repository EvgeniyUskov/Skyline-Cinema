import YandexMoneyCoreApi

public enum IdentificationApiError: Error, JsonApiResponse, IdentificationErrorApiResponse, Decodable, Encodable {

    case parameters(type: IdentificationTypeError.BadRequest,
                    parameterNames: [String],
                    headerNames: [String],
                    operationName: String?)

    case authorization(type: IdentificationTypeError.Unauthorized)

    case technical(type: IdentificationTypeError.InternalServerError, retryAfter: String?)

    case notFound

    case mappingError

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard let errorContainer = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .error) else {
            throw DecodingError.isNotError
        }

        if let type = try? errorContainer.decode(IdentificationTypeError.BadRequest.self, forKey: .type) {
            let parameterNames = try errorContainer.decodeIfPresent([String].self, forKey: .parameterNames) ?? []
            let headerNames = try errorContainer.decodeIfPresent([String].self, forKey: .headerNames) ?? []
            let operationName = try errorContainer.decodeIfPresent(String.self, forKey: .operationName)
            self = .parameters(type: type,
                               parameterNames: parameterNames,
                               headerNames: headerNames,
                               operationName: operationName)
        } else if let type = try? errorContainer.decode(IdentificationTypeError.Unauthorized.self, forKey: .type) {
            self = .authorization(type: type)
        } else if let type = try? errorContainer.decode(IdentificationTypeError.InternalServerError.self,
                                                        forKey: .type) {
            let interval = try errorContainer.decodeIfPresent(String.self, forKey: .retryAfter)
            self = .technical(type: type, retryAfter: interval)
        } else if (try? errorContainer.decode(IdentificationTypeError.NotFound.self, forKey: .type)) != nil {
            self = .notFound
        } else {
            throw DecodingError.unknownError
        }
    }

    enum DecodingError: Error {
        case isNotError
        case unknownError
    }

    // MARK: - Encodable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var errorContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .error)

        switch self {
        case let .parameters(type, parameterNames, headerNames, operationName):
            try errorContainer.encode(type, forKey: .type)

            if parameterNames.isEmpty == false {
                try errorContainer.encode(parameterNames, forKey: .parameterNames)
            }

            if headerNames.isEmpty == false {
                try errorContainer.encode(headerNames, forKey: .headerNames)
            }

            try errorContainer.encodeIfPresent(operationName, forKey: .operationName)
        case let .authorization(type):
            try errorContainer.encode(type, forKey: .type)
        case let .technical(type, interval):
            try errorContainer.encode(type, forKey: .type)
            try errorContainer.encodeIfPresent(interval, forKey: .retryAfter)
        case .notFound:
            try errorContainer.encode(IdentificationTypeError.NotFound.notFound, forKey: .type)
        case .mappingError:
            throw EncodingError.internalError
        }
    }

    enum EncodingError: Error {
        case internalError
    }

    private enum CodingKeys: String, CodingKey {
        case error
        case type
        case parameterNames
        case headerNames
        case operationName
        case retryAfter
    }

}
