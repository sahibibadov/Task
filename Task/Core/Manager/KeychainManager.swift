//
//  KeychainManager.swift
//  Task
//
//  Created by Sahib on 14.04.25.
//

import  Foundation

protocol AuthKeychainManagerProtocol {
    func saveUser(_ user: User) -> Bool
    func getUser() -> User?
    func deleteUser() -> Bool
    func isEmailRegistered(_ email: String) -> Bool
}

final class AuthKeychainManager: AuthKeychainManagerProtocol {
    private let keychainService: KeychainProtocol
    
    init(keychainService: KeychainProtocol = KeychainService()) {
        self.keychainService = keychainService
    }
    
    func saveUser(_ user: User) -> Bool {
        let encoder = JSONEncoder()
        guard let userData = try? encoder.encode(user),
              let userString = String(data: userData, encoding: .utf8) else {
            return false
        }
        
        return keychainService.save(service: "currentUser", data: userString)
    }
    
    func getUser() -> User? {
        guard let userString = keychainService.load(service: "currentUser"),
              let userData = userString.data(using: .utf8) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        return try? decoder.decode(User.self, from: userData)
    }
    
    func deleteUser() -> Bool {
        return keychainService.delete(service: "currentUser")
    }
    
    func isEmailRegistered(_ email: String) -> Bool {
        guard let user = getUser() else { return false }
        return user.email.lowercased() == email.lowercased()
    }
}
