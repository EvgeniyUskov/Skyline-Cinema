import YandexMoneyCoreApi
import typealias FunctionalSwift.Result

public protocol ShowcaseApiResponse: ApiResponse {}

extension ShowcaseApiResponse {
    public static func process(response: HTTPURLResponse?, data: Data?, error: Error?) -> Result<Self> {
        var result: Result<Self>

        if let response = response,
           let data = data,
           let serializedData = self.makeResponse(response: response, data: data) {
            result = .right(serializedData)
        } else if response?.statusCode == 301,
            let location = response?.allHeaderFields[HeaderConstants.location] as? String {
            result = .left(ShowcaseApiError.moved(location))
        } else if let error = error {
            result = .left(error)
        } else {
            result = .left(ShowcaseApiError.mappingError)
        }

        return result
    }
}
