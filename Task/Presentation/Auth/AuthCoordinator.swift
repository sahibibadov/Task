//
//  AuthCoordinator.swift
//  Task
//
//  Created by Sahib on 14.04.25.
//

import Foundation

import UIKit.UINavigationController

protocol AuthCoordinatorDelegate : AnyObject {
    func changeRootMain()
}

final class AuthCoordinator  : Coordinator {
    var parentCoordinator: Coordinator?
    weak var delegate: AuthCoordinatorDelegate?
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = LoginController(viewModel: .init(navigation: self,authManager: AuthKeychainManager()))
        showController(vc: controller)
    }
    
}

extension AuthCoordinator : AuthNavigation {
    
    func showLogin() {
        navigationController.popViewController(animated: true)
    }
    
    func showRegister() {
        let controller = RegisterController(
            viewModel: .init(navigation: self,authManager: AuthKeychainManager())
        )
        showController(vc: controller)
    }
    
    func showHome() {
        delegate?.changeRootMain()
    }
}
