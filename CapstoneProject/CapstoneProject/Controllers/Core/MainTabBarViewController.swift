//
//  MainTabBarViewController.swift
//  CapstoneProject
//
//  Created by Ensar Batuhan Ünverdi on 10.08.2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
    }
}

extension MainTabBarViewController {
    
    func setUpTabBar() {
        guard let item = self.tabBar.items else {
            return
        }
        item[0].title = "Movies".localized()
        item[1].title = "Favourites".localized()
        item[2].title = "Search".localized()
    }
}
