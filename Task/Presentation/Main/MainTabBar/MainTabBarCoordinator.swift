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
        let homeItem = UITabBarItem()
        homeItem.title = "Home"
        homeItem.image = UIImage(systemName: "house")
        homeItem.selectedImage = UIImage(systemName: "house.fill")
        homeNavController.tabBarItem = homeItem
        
        //profile
        let profileNavController = UINavigationController()
        profileCoordinator = ProfileCoordinator(navigationController: profileNavController)
        profileCoordinator?.parentCoordinator = parentCoordinator
        profileCoordinator?.delegate = self
        let favItem = UITabBarItem()
        favItem.title = "Profile"
        favItem.image = UIImage(systemName: "person")
        favItem.selectedImage = UIImage(systemName: "person.fill")
        profileNavController.tabBarItem = favItem
        
        
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
