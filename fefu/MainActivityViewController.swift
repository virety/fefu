//
//  MainActivityViewController.swift
//  fefu
//
//  Created by Вадим Семибратов on 25.11.2024.
//

import UIKit

class MainActivityViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let activitiesVC = ActivityViewController()
        let profileVC = ProfileViewController()
        let activitiesNavController = UINavigationController(rootViewController: activitiesVC)
        let profileNavController = UINavigationController(rootViewController: profileVC)
        activitiesVC.tabBarItem = UITabBarItem(title: "Активности", image: UIImage(systemName: "list.dash"), tag: 0)
        profileVC.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person"), tag: 1)
        self.viewControllers = [activitiesNavController, profileNavController]
    }
}
