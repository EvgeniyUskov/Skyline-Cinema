/*
 * The MIT License
 *
 * Copyright (c) 2007—2018 NBCO Yandex.Money LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

/// ISO-4217 3-alpha character code of payment currency.
public enum CurrencyCode: String, Codable {
    /// The Russian ruble or rouble is the currency of the Russian Federation.
    case rub = "RUB"
    /// The United States dollar is the official currency of the United States.
    case usd = "USD"
    /// The euro is the official currency of the European Union.
    case eur = "EUR"
}

// MARK: - Making currency symbol

public extension CurrencyCode {

    /// Depending on the currency, returns a currency symbol.
    var currencySymbol: Character {
        let result: Character
        switch self {
        case .rub:
            result = "₽"
        case .eur:
            result = "€"
        case .usd:
            result = "$"
        }
        return result
    }
}
