public enum DateElement: Decodable, Encodable {

    /// Строка формата YYYY-MM-DD
    case date(String)

    /// Строка формата YYYY-MM
    case month(String)

    /// Текущая дата
    case now

    /** Период формата PnYnMnD
        P — символ "Period";
        nY — количество лет (например 3Y);
        nM — количество месяцев (например 10M);
        nD — количество дней (например 5D).
     */
    indirect case featurePeriod(DateElement, String)
    indirect case pastPeriod(String, DateElement)

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        let string = try container.decode(String.self)

        if let separatorIndex = string.firstIndex(of: Constants.separator) {
            let afterSeparatorIndex = string.index(after: separatorIndex)
            let left = String(string[..<separatorIndex])
            let right = String(string[afterSeparatorIndex...])

            if left.hasPrefix(Constants.period) {
                let date = try DateElement.makeDateElement(string: right)
                self = .pastPeriod(left, date)
            } else if right.hasPrefix(Constants.period) {
                let date = try DateElement.makeDateElement(string: left)
                self = .featurePeriod(date, right)
            } else {
                throw DecodingError.incorrectDateElement
            }
        } else {
            self = try DateElement.makeDateElement(string: string)
        }
    }

    enum DecodingError: Error {
        case incorrectDateElement
    }

    private static func makeDateElement(string: String) throws -> DateElement {
        if string.count == Constants.dateLength {
            return DateElement.date(string)
        } else if string.count == Constants.monthLength {
            return DateElement.month(string)
        } else if string == Constants.now {
            return DateElement.now
        } else {
            throw DecodingError.incorrectDateElement
        }
    }

    // MARK: - Encodable

    public func encode(to encoder: Encoder) throws {
        var data: String
        switch self {
        case let .month(string):
            data = string
        case let .date(string):
            data = string
        case .now:
            data = "now"
        case let .pastPeriod(left, right):
            let right = try DateElement.makeString(dateElement: right)
            data = left + String(Constants.separator) + right
        case let .featurePeriod(left, right):
            let left = try DateElement.makeString(dateElement: left)
            data = left + String(Constants.separator) + right
        }

        var container = encoder.singleValueContainer()
        try container.encode(data)
    }

    private static func makeString(dateElement: DateElement) throws -> String {
        let string: String
        switch dateElement {
        case let .month(date):
            string = date
        case let .date(date):
            string = date
        case .now:
            string = "now"
        default:
            throw EncodingError.incorrectDateElement
        }
        return string
    }

    enum EncodingError: Error {
        case incorrectDateElement
    }

    private enum Constants {
        static let separator: Character = "/"
        static let period = "P"
        static let now = "now"
        static let dateLength = 10
        static let monthLength = 7
    }
}
