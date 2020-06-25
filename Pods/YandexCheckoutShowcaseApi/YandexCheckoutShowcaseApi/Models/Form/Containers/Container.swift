import Foundation

/// Базовый протокол контейнера.
public protocol Container: Form {

    /// Наименование контейнера.
    var name: String? { get }

    /// Правила отображения контейнера.
    var display: ContainerDisplayType { get }
}
