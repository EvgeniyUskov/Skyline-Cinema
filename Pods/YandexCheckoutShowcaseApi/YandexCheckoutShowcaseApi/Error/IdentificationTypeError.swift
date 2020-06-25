import Foundation

public enum IdentificationTypeError {

    public enum BadRequest: String, Decodable, Encodable {
        case syntax = "SyntaxError"
        case illegalParameters = "IllegalParameters"
        case illegalHeaders = "IllegalHeaders"
        case notSupported = "NotSupported"
    }

    public enum Unauthorized: String, Decodable, Encodable {
        case invalidToken = "InvalidToken"
        case invalidCredentials = "InvalidCredentials"
    }

    public enum InternalServerError: String, Decodable, Encodable {
        case technical = "TechnicalError"
        case unavailable = "ServiceUnavailable"
    }

    public enum NotFound: String, Decodable, Encodable {
        case notFound = "NotFound"
    }
}
