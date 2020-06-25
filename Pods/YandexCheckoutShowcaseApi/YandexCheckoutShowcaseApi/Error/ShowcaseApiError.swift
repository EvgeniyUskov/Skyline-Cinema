import Foundation
import YandexMoneyCoreApi

public enum ShowcaseApiError: Error {

    case mappingError

    /// Вместо запрошенной формы оплаты следует использовать другую форму
    case moved(String)
}
