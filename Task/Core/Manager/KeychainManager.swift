//
//  KeychainManager.swift
//  Task
//
//  Created by Sahib on 14.04.25.
//

import  Foundation

protocol AuthKeychainManagerProtocol {
    func saveUser(_ user: User) -> Bool
    func getUser(email: String) -> User?
    func deleteUser(email: String) -> Bool
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
        
        return keychainService.save(service: user.email.lowercased(), data: userString)
    }
    
    func getUser(email: String) -> User? {
        guard let userString = keychainService.load(service: email.lowercased()),
              let userData = userString.data(using: .utf8) else {
            return nil
        }
        let decoder = JSONDecoder()
        return try? decoder.decode(User.self, from: userData)
    }
    
    func deleteUser(email: String) -> Bool {
        return keychainService.delete(service: email.lowercased())
    }
    
    func isEmailRegistered(_ email: String) -> Bool {
        return getUser(email: email) != nil
    }
}
