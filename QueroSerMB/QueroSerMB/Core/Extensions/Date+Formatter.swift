//
//  Date+Formatter.swift
//  QueroSerMB
//
//  Created by Guilherme Prata Costa on 14/09/24.
//

import Foundation

enum DateFormat: String {
    case iso8601 = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS'Z'"
    case displayFormat = "dd/MM/yyyy HH:mm"
    case shortDate = "dd/MM/yyyy"
    case timeOnly = "HH:mm:ss"
    
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = self.rawValue
        return formatter
    }
}

extension Date {
    static func fromString(_ dateString: String, format: DateFormat) -> Date? {
        return format.formatter.date(from: dateString)
    }
    
    func toString(format: DateFormat = .displayFormat) -> String {
        return format.formatter.string(from: self)
    }
}

extension String {
    func toDate(format: DateFormat = .iso8601) -> Date? {
        return Date.fromString(self, format: format)
    }
}
