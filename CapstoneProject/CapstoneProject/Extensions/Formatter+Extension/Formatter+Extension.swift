//
//  Formatter+Extension.swift
//  CapstoneProject
//
//  Created by Ensar Batuhan Ünverdi on 27.07.2022.
//

import Foundation

extension Formatter {
    static let number = NumberFormatter()
}

extension Locale {
    static let englishUS: Locale = .init(identifier: "en_US")
}

extension Numeric {
    var currency: String { formatted(style: .currency) }
    var currencyUS: String { formatted(style: .currency, locale: .englishUS) }

    func formatted(with groupingSeparator: String? = nil, style: NumberFormatter.Style, locale: Locale = .current) -> String {
        Formatter.number.locale = locale
        Formatter.number.numberStyle = style
        if let groupingSeparator = groupingSeparator {
            Formatter.number.groupingSeparator = groupingSeparator
        }
        return Formatter.number.string(for: self) ?? ""
    }
}
