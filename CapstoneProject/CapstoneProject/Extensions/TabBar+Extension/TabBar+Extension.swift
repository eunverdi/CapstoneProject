//
//  TabBar+Extension.swift
//  CapstoneProject
//
//  Created by Ensar Batuhan Ünverdi on 10.08.2022.
//

import Foundation
import UIKit

extension MainTabBarViewController: UITabBarControllerDelegate {
    
    func setUpTabBar() {
        guard let item = self.tabBar.items else {
            return
        }
        item[0].title = "Movies".localized()
        item[1].title = "Favourites".localized()
        item[2].title = "Search".localized()
    }
}
