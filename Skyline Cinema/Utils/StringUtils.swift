//
//  StringUtils.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 16.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation

    extension StringProtocol where Index == String.Index {
        func index(of string: Self, options: String.CompareOptions = []) -> Index? {
            return range(of: string, options: options)?.lowerBound
        }
        func endIndex(of string: Self, options: String.CompareOptions = []) -> Index? {
            return range(of: string, options: options)?.upperBound
        }
        func indexes(of string: Self, options: String.CompareOptions = []) -> [Index] {
            var result: [Index] = []
            var start = startIndex
            while start < endIndex,
                let range = self[start..<endIndex].range(of: string, options: options) {
                result.append(range.lowerBound)
                start = range.lowerBound < range.upperBound ? range.upperBound :
                        index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
            }
            return result
        }
        func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>] {
            var result: [Range<Index>] = []
            var start = startIndex
            while start < endIndex,
                let range = self[start..<endIndex].range(of: string, options: options) {
                result.append(range)
                start = range.lowerBound < range.upperBound ? range.upperBound :
                        index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
            }
            return result
        }
    }

extension String {
    static func priceFormat(_ double: Double) -> String {
        return String(format: "%.0f", double)
    }

    static func rateFormat(_ double: Double) -> String {
        return String(format: "%.1f", double)
    }
}
