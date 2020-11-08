//
//  AppDelegate.swift
//  MyHabits
//
//  Created by Pavel Yurkov on 05.11.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // создаем и предварительно настраиваем navigationController'ы, которые будут лежать в tabBarViewController
    private lazy var habitsViewController: UINavigationController = {
        let nc = UINavigationController(rootViewController: HabitsViewController())
        nc.title = "Привычки"
        nc.tabBarItem.image = UIImage(named: "habits_tab_icon")
        return nc
    }()
    
    private lazy var infoViewController: UINavigationController = {
        let nc = UINavigationController(rootViewController: InfoViewController())
        nc.title = "Информация"
        nc.tabBarItem.image = UIImage(systemName: "info.circle.fill")
        return nc
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // создаем таб бар контроллер и кладем в него другие вьюКонтроллеры, обернутые в UINavigationController
        let tabBarViewController = UITabBarController()
        tabBarViewController.tabBar.tintColor = ColorPalette.primaryColor
        let tabBarViewControllers = [habitsViewController, infoViewController]
        tabBarViewController.setViewControllers(tabBarViewControllers, animated: false)
        
        // создаем window и указываем для него rootViewController
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarViewController
        window?.makeKeyAndVisible()
        
        return true
    }

}

