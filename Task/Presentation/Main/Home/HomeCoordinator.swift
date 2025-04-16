//
//  HomeCoordinator.swift
//  Task
//
//  Created by Sahib on 14.04.25.
//

import Foundation
import UIKit.UINavigationController

final class HomeCoordinator : Coordinator {
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = HomeController(viewModel: HomeViewModel(navigation: self))
        showController(vc: controller)
    }
    
}

extension HomeCoordinator : HomeNavigation {
    func returnHome() {
        navigationController.popViewController(animated: true)
    }
    
    func showTransfer(cards: [CardModel]) {
        let controller = TransferController(
            viewModel: .init(navigation: self,cards: cards)
        )
        controller.hidesBottomBarWhenPushed =  true
        showController(vc: controller)
    }
    
    
}
