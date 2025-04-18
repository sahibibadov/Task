//
//  ProfileViewModel.swift
//  Task
//
//  Created by Sahib on 14.04.25.
//

import Foundation

final class ProfileViewModel {
    weak var navigation: ProfileNavigation?
    
    private let authManager: AuthKeychainManagerProtocol
    
    init(navigation: ProfileNavigation, authManager: AuthKeychainManagerProtocol) {
        self.navigation = navigation
        self.authManager = authManager
    }
    
    func logOut (){
            navigation?.showLogin()
    }
}
