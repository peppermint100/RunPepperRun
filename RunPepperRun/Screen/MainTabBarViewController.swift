//
//  MainTabBarViewController.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/7/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tabBar.isTranslucent = false
        tabBar.tintColor = .label
        
        let runningVC = UINavigationController(rootViewController: RunningViewController())
        let statisticVC = UINavigationController(rootViewController: StatisticViewController())
        let settingsVC = UINavigationController(rootViewController: SettingsViewController())
        
        runningVC.tabBarItem.image = UIImage(systemName: "figure.run")
        statisticVC.tabBarItem.image = UIImage(systemName: "chart.bar.fill")
        settingsVC.tabBarItem.image = UIImage(systemName: "gearshape.fill")
        
        runningVC.title = "러닝"
        statisticVC.title = "통계"
        settingsVC.title = "설정"
        
        setViewControllers([runningVC, statisticVC, settingsVC], animated: true)
    }
}
