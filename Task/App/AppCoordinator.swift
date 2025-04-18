//
//  AppCoordinator.swift
//  Task
//
//  Created by Sahib on 14.04.25.
//


import Foundation

import UIKit.UINavigationController

final class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    private let window : UIWindow
    
    var isLogin: Bool = UserDefaultsService.isLoggedIn()
    init(navigationController: UINavigationController, window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
    }
    
    
    @MainActor
    @objc private func  listener (){
        DispatchQueue.main.async{ [weak self] in
            guard let self = self else { return }
            self.start()
        }
    }
    
    func start() {	
        if isLogin {
            showHome()
        } else {
            showAuth()
        }
    }
    
    fileprivate func showAuth() {
        navigationController.setViewControllers([], animated: false)
        children.removeAll()
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.delegate = self
        children.append(authCoordinator)
        authCoordinator.parentCoordinator = self
        authCoordinator.start()
    }
    
    fileprivate func showHome() {
        navigationController.setViewControllers([], animated: false)
        children.removeAll()
        let mainTabBar = MainTabBarCoordinator(navigationController: navigationController)
        mainTabBar.delegate = self
        children.append(mainTabBar)
        mainTabBar.parentCoordinator = self
        mainTabBar.start()
    }
    
    
}

extension AppCoordinator : AuthCoordinatorDelegate, MainTabBarCoordinatorDelegate {
    func changeRootAuth() {
        isLogin =  UserDefaultsService.setIsLoggedIn(false)
        start()
    }
    
    func changeRootMain() {
        isLogin =  UserDefaultsService.setIsLoggedIn(true)
        start()
    }
    
}
