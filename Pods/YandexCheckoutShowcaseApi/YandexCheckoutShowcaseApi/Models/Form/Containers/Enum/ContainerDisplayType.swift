import Foundation

public enum ContainerDisplayType: String, Decodable, Encodable {

    /// Отображение контейнера обязательно всеми клиентами
    case mandatory

    /// Клиент самостоятельно принимает решение отображать или нет этот контейнер
    case optional
}
