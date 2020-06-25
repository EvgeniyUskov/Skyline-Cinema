import Foundation

public enum ContainerElement: Decodable, Encodable {

    /// Элемент UI контрола
    case control(Control)

    /// Элемент контейнера
    case container(Container)

    // MARK: - Decodable

    // swiftlint:disable cyclomatic_complexity

    public init(from decoder: Decoder) throws {
        let typeContainer = try decoder.container(keyedBy: CodingKeys.self)
        let type = try typeContainer.decode(FormType.self, forKey: .type)

        let container = try decoder.singleValueContainer()

        switch type {
        case .text:
            let control = try container.decode(TextControl.self)
            self = .control(control)
        case .number:
            let control = try container.decode(NumberControl.self)
            self = .control(control)
        case .amount:
            let control = try container.decode(AmountControl.self)
            self = .control(control)
        case .email:
            let control = try container.decode(EmailControl.self)
            self = .control(control)
        case .tel:
            let control = try container.decode(PhoneControl.self)
            self = .control(control)
        case .checkbox:
            let control = try container.decode(CheckboxControl.self)
            self = .control(control)
        case .date:
            let control = try container.decode(DateControl.self)
            self = .control(control)
        case .month:
            let control = try container.decode(MonthControl.self)
            self = .control(control)
        case .select:
            let control = try container.decode(SelectControl.self)
            self = .control(control)
        case .textarea:
            let control = try container.decode(TextAreaControl.self)
            self = .control(control)
        case .submit:
            let control = try container.decode(SubmitControl.self)
            self = .control(control)
        case .group:
            let control = try container.decode(GroupContainer.self)
            self = .container(control)
        case .p:
            let control = try container.decode(ParagraphContainer.self)
            self = .container(control)
        case .header:
            let control = try container.decode(HeaderContainer.self)
            self = .container(control)
        case .ul:
            let control = try container.decode(UnorderedListContainer.self)
            self = .container(control)
        case .ol:
            let control = try container.decode(OrderedListContainer.self)
            self = .container(control)
        case .dl:
            let control = try container.decode(DefinitionListContainer.self)
            self = .container(control)
        case .img:
            let control = try container.decode(ImageContainer.self)
            self = .container(control)
        case .video:
            let control = try container.decode(VideoContainer.self)
            self = .container(control)
        case .a:
            throw DecodingError.unsupportedElement
        }
    }

    enum DecodingError: Error {
        case unsupportedElement
    }

    // MARK: - Encodable

    public func encode(to encoder: Encoder) throws {
        var singleValueContainer = encoder.singleValueContainer()
        switch self {
        case let .container(container):
            switch container {
            case let container as GroupContainer:
                try singleValueContainer.encode(container)
            case let container as ParagraphContainer:
                try singleValueContainer.encode(container)
            case let container as HeaderContainer:
                try singleValueContainer.encode(container)
            case let container as UnorderedListContainer:
                try singleValueContainer.encode(container)
            case let container as OrderedListContainer:
                try singleValueContainer.encode(container)
            case let container as DefinitionListContainer:
                try singleValueContainer.encode(container)
            case let container as ImageContainer:
                try singleValueContainer.encode(container)
            case let container as VideoContainer:
                try singleValueContainer.encode(container)
            default:
                throw EncodingError.unsupportedElement
            }
        case let .control(control):
            switch control {
            case let control as TextControl:
                try singleValueContainer.encode(control)
            case let control as NumberControl:
                try singleValueContainer.encode(control)
            case let control as AmountControl:
                try singleValueContainer.encode(control)
            case let control as EmailControl:
                try singleValueContainer.encode(control)
            case let control as PhoneControl:
                try singleValueContainer.encode(control)
            case let control as DateControl:
                try singleValueContainer.encode(control)
            case let control as MonthControl:
                try singleValueContainer.encode(control)
            case let control as SelectControl:
                try singleValueContainer.encode(control)
            case let control as TextAreaControl:
                try singleValueContainer.encode(control)
            case let control as SubmitControl:
                try singleValueContainer.encode(control)
            case let control as CheckboxControl:
                try singleValueContainer.encode(control)
            default:
                throw EncodingError.unsupportedElement
            }
        }
    }

    // swiftlint:enable cyclomatic_complexity

    enum EncodingError: Error {
        case unsupportedElement
    }

    private enum CodingKeys: String, CodingKey {
        case type
    }
}
