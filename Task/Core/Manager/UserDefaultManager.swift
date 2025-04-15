//
//  UserDefaultManager.swift
//  Task
//
//  Created by Sahib on 14.04.25.
//

import Foundation

class UserDefaultsService {
    
    static func setIsLoggedIn(_ value: Bool) -> Bool {
        UserDefaultsHelper.setBool(key: .isLoggedIn, value: value)
        return value
    }
    
    static func clearUserData() {
        UserDefaultsHelper.remove(key: .isLoggedIn)
    }
    
    static func isLoggedIn() -> Bool {
        return UserDefaultsHelper.getBool(key: .isLoggedIn)
    }
}
