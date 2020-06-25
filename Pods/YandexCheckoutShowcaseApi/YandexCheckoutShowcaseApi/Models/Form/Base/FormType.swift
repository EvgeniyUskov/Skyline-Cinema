public enum FormType: String, Decodable, Encodable {

    /// Однострочный текст.
    case text

    /// Целые числа и числа с фиксированной точкой.
    case number

    /// Сумма.
    case amount

    /// Электронная почта.
    case email

    /// Номера телефона.
    case tel

    /// Чекбокс.
    case checkbox

    /// Полная дата.
    case date

    /// Месяц и год.
    case month

    /// Выбор одного значения из списка.
    case select

    /// Многострочный текст.
    case textarea

    /// Отправка формы.
    case submit

    /// Группа содержит список UI-контролов и/или вложенных контейнеров.
    case group

    /// Блок статического текста, может содержать гиперссылки.
    case p

    /// Заголовок
    case header

    /// Маркированный список
    case ul

    /// Нумерованный список
    case ol

    /// Парный список
    case dl

    /// Изображение
    case img

    /// Видео
    case video

    /// Гиперссылка
    case a
}
