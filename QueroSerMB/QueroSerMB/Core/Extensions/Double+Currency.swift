//
//  Double+Currency.swift
//  QueroSerMB
//
//  Created by Guilherme Prata Costa on 14/09/24.
//

import Foundation

enum CurrencyFormat {
    case usd
    case eur
    case brl
    case custom(symbol: String)
    
    var symbol: String {
        switch self {
        case .usd: return "$"
        case .eur: return "€"
        case .brl: return "R$"
        case .custom(let symbol): return symbol
        }
    }
}

extension Double {
    func toCurrency(_ format: CurrencyFormat = .usd, decimalPlaces: Int = 2, locale: Locale = .current) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = decimalPlaces
        formatter.maximumFractionDigits = decimalPlaces
        formatter.locale = locale
        
        if case .custom = format {
            formatter.currencySymbol = format.symbol
        }
        
        if let formattedString = formatter.string(from: NSNumber(value: self)) {
            if case .usd = format, locale.currencySymbol != "$" {
                return formattedString.replacingOccurrences(of: locale.currencySymbol ?? "", with: "$")
            } else if case .eur = format, locale.currencySymbol != "€" {
                return formattedString.replacingOccurrences(of: locale.currencySymbol ?? "", with: "€")
            } else if case .brl = format, locale.currencySymbol != "R$" {
                return formattedString.replacingOccurrences(of: locale.currencySymbol ?? "", with: "R$")
            }
            return formattedString
        }
        
        return "\(format.symbol)\(String(format: "%.\(decimalPlaces)f", self))"
    }
}
