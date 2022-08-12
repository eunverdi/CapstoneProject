//
//  String+Extension.swift
//  CapstoneProject
//
//  Created by Ensar Batuhan Ünverdi on 26.07.2022.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
