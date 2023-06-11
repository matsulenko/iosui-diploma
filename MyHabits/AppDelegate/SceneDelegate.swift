//
//  SceneDelegate.swift
//  MyHabits
//
//  Created by Matsulenko on 24.05.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        
        let habitsViewController = HabitsViewController()
        let infoViewController = InfoViewController()
        
        let tabBarController = UITabBarController()
        habitsViewController.tabBarItem = UITabBarItem(title: "Привычки", image: UIImage(systemName: "rectangle.grid.1x2.fill"), tag: 0)
        infoViewController.tabBarItem = UITabBarItem(title: "Информация", image: UIImage(systemName: "info.circle.fill"), tag: 1)
        let controllers = [habitsViewController, infoViewController]
        
        tabBarController.viewControllers = controllers.map {
            UINavigationController(rootViewController:  $0)
        }
        tabBarController.selectedIndex = 0
        tabBarController.tabBar.backgroundColor = UIColor(named: "TabBarBackground")
        tabBarController.tabBar.tintColor = UIColor(named: "MyPurple")
        
        window?.rootViewController = tabBarController
                
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

