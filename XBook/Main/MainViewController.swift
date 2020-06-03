//
//  MainViewController.swift
//  XBook
//
//  Created by Ganang Arief Pratama on 01/06/20.
//  Copyright © 2020 Infinity. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        tabBar.barTintColor = .white
        setupTabbar()
    }
    
    func setupTabbar() {
        let exerciseVC = UINavigationController(rootViewController: ExerciseViewController())
        exerciseVC.tabBarItem = UITabBarItem(title: "Exercise", image: UIImage(named: "exerciseIcon"), tag: 0)
        
        let progressVC = UINavigationController(rootViewController: ProgressViewController())
        progressVC.tabBarItem = UITabBarItem(title: "Progress", image: UIImage(systemName: "chart.bar"), tag: 1)
        
        let rewardVC = UINavigationController(rootViewController: RewardViewController())
        rewardVC.tabBarItem = UITabBarItem(title: "Reward", image: UIImage(systemName: "gift.fill"), tag: 2)
        
        self.viewControllers = [exerciseVC, progressVC, rewardVC]
        
    }
    
}
