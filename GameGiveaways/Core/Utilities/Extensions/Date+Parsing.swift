//
//  Date+Extensions.swift
//  GameGiveaways
//
//  Created by mac on 26/01/2025.
//

import Foundation

extension Date {
    /// Parses a date string into a `Date` object using the provided format.
    ///
    /// - Parameters:
    ///   - dateString: The date string to parse.
    ///   - format: The date format string (default: "yyyy-MM-dd H:mm:ss").
    /// - Returns: A `Date` object if parsing is successful, otherwise `nil`.
    static func parse(from dateString: String, format: String = "yyyy-MM-dd H:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: dateString)
    }
}
