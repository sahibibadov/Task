//
//  ProfileCoordinator.swift
//  Task
//
//  Created by Sahib on 14.04.25.
//


import Foundation
import UIKit.UINavigationController

protocol ProfileDelegate : AnyObject {
    func showLogin()
}

final class ProfileCoordinator : Coordinator {
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    weak var delegate : ProfileDelegate?
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = ProfileController(
            viewModel: ProfileViewModel(navigation: self,authManager: AuthKeychainManager())
        )
        showController(vc: controller)
    }
    
}

extension ProfileCoordinator : ProfileNavigation {
    func showLogin() {
        delegate?.showLogin()
    }
    
}
