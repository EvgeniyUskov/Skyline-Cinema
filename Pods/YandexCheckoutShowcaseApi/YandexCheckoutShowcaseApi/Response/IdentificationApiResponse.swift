import YandexMoneyCoreApi
import typealias FunctionalSwift.Result

public protocol IdentificationApiResponse: ApiResponse {}

extension IdentificationApiResponse {
    public static func process(response: HTTPURLResponse?, data: Data?, error: Error?) -> Result<Self> {
        var result: Result<Self>

        if let response = response,
            let data = data,
            let error = IdentificationApiError.makeResponse(response: response, data: data) {
            result = .left(error)
        } else if let response = response,
            let data = data,
            let serializedData = self.makeResponse(response: response, data: data) {
            result = .right(serializedData)
        } else if let error = error {
            result = .left(error)
        } else {
            result = .left(IdentificationApiError.mappingError)
        }

        return result
    }
}
