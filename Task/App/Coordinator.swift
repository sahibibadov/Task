//
//  Coordinator.swift
//  Task
//
//  Created by Sahib on 14.04.25.
//

import Foundation
import UIKit.UINavigationController


protocol Coordinator : AnyObject {
    var parentCoordinator: Coordinator? { get set } // esas coordinatorumuz olanda biz bunu chaghirib = self
    var children: [Coordinator] { get set } // bu ise iche iche coordinatorlar achilacaq bunu biz listimizde saxlayacayiq eger ehtiyac varsa
    var navigationController : UINavigationController { get set } // bize lazim olan navigationu burdan set edirik
    func start() // ilk bashlayan controller burda chaghrilacaq
}

extension Coordinator {
    
    /// Removing a coordinator inside a children. This call is important to prevent memory leak.
    /// - Parameter coordinator: Coordinator that finished.
    func childDidFinish(_ coordinator : Coordinator){
        // Call this if a coordinator is done.
        for (index, child) in children.enumerated() {
            if child === coordinator {
                children.remove(at: index)
                break
            }
        }
    }
    
    func showController(vc: UIViewController) {
        navigationController.show(vc, sender: nil)
    }
    
    
}
