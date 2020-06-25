public protocol Form: Decodable, Encodable {

    /// Тип UI-контрола
    var type: FormType { get }
}
