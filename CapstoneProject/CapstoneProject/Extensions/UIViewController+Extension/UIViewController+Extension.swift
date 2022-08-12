//
//  UIViewController+Extension.swift
//  CapstoneProject
//
//  Created by Ensar Batuhan Ünverdi on 25.07.2022.
//

import Foundation
import UIKit

extension UIViewController {

    static var identifier: String {
        return String(describing: self)
    }

    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
    }
}
