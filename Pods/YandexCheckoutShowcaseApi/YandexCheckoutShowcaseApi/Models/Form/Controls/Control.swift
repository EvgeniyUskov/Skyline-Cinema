/// Общий протокол описания UI-контролов.
public protocol Control: Form {

    /// Имя поля формы, имя параметра запроса отправки данных формы.
    var name: String { get }

    /// Предварительно заполненное значение контрола (кроме checkbox).
    var value: String? { get }

    /**
        Макрос автоподстановки для предварительного заполнения значения поля клиентом.
        Если клиент обрабатывает макросы, то их значение переопределяет value.
     */
    var autofillValue: Autofill? { get }

    /// Подсказка для покупателя о назначении и формате данных поля.
    var hint: String? { get }

    /// Наименование поля формы для отображения покупателю, надпись над контролом.
    var label: String? { get }

    /**
        Текст ошибки, который следует отображать покупателю при ошибке проверки введенных в данное поле данных.
        Текст предназначен для отображения при ошибке проверки данных на стороне приложения клиента.
     */
    var alert: String? { get }

    /// Обязательность заполнения поля покупателем. По умолчанию true.
    var required: Bool { get }

    /// Признак запрета изменения значения поля формы. По умолчанию false.
    var readonly: Bool { get }
}