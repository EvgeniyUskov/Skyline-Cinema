/// Размер заголовка, возможные значения от 1 (наибольший) до 6 (наименьший).
public enum HeaderRank: Int, Decodable, Encodable {
    case header1 = 1
    case header2
    case header3
    case header4
    case header5
    case header6
}
