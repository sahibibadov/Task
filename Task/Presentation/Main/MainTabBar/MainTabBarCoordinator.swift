//
//  MainTabBarCoordinator.swift
//  MovieApp-atl
//
//  Created by Sahib on 17.03.25.
//


import UIKit


protocol MainTabBarCoordinatorDelegate : AnyObject {
    func changeRootAuth()
}

final class MainTabBarCoordinator : Coordinator {
    
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    weak var delegate: MainTabBarCoordinatorDelegate?
    
    private let tabBarController = TabBarController()
    
    
    private var homeCoordinator: HomeCoordinator?
    private var profileCoordinator: ProfileCoordinator?
    
    init(
        navigationController : UINavigationController
    ) {
        self.navigationController = navigationController
        self.navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func start() {
        initializeHomeTabBar()
    }
    
    deinit {
        print(#function)
    }
    
    private func initializeHomeTabBar() {
        //home
        let homeNavController = UINavigationController()
        homeCoordinator = HomeCoordinator(navigationController: homeNavController)
        homeCoordinator?.parentCoordinator = parentCoordinator
        if let homeIcon = UIImage(systemName: "house"), let homeIconSelected = UIImage(systemName: "house.fill") {
            homeNavController.tabBarItem = UITabBarItem(title: "Home", image: homeIcon, selectedImage: homeIconSelected)
        }
        
        //profile
        let profileNavController = UINavigationController()
        profileCoordinator = ProfileCoordinator(navigationController: profileNavController)
        profileCoordinator?.parentCoordinator = parentCoordinator
        profileCoordinator?.delegate = self
        if let profileIcon = UIImage(systemName: "person"), let profileIconSelected = UIImage(systemName: "person.fill") {
            profileNavController.tabBarItem = UITabBarItem(title: "Profile", image: profileIcon, selectedImage: profileIconSelected)
        }
        
        
        tabBarController.viewControllers = [
            homeNavController,
            profileNavController
        ]
        
        navigationController.pushViewController(tabBarController, animated: true)
        
        parentCoordinator?.children
            .append(
                homeCoordinator ?? HomeCoordinator(navigationController: UINavigationController())
                
            )
        parentCoordinator?.children.append(
            profileCoordinator ?? ProfileCoordinator(
                navigationController: UINavigationController())
        )
        homeCoordinator?.start()
        profileCoordinator?.start()
    }
}

extension MainTabBarCoordinator: ProfileDelegate {
    func showLogin() {
        delegate?.changeRootAuth()
    }
}
