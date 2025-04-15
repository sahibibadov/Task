//
//  KeychainService.swift
//  Task
//
//  Created by Sahib on 14.04.25.
//

import Foundation
import Security

protocol KeychainProtocol {
    func save(service: String, data: String) -> Bool
    func load(service: String) -> String?
    func update(service: String, data: String) -> Bool
    func delete(service: String) -> Bool
}

class KeychainService: KeychainProtocol {
    
    func save(service: String, data: String) -> Bool {
        if let dataFromString = data.data(using: .utf8, allowLossyConversion: false) {
            let keychainQuery: NSMutableDictionary = [
                kSecClass as NSString: kSecClassGenericPassword,
                kSecAttrService as NSString: service,
                kSecValueData as NSString: dataFromString
            ]
            
            let status = SecItemAdd(keychainQuery as CFDictionary, nil)
            return status == errSecSuccess
        }
        return false
    }
    
    func load(service: String) -> String? {
        let keychainQuery: NSMutableDictionary = [
            kSecClass as NSString: kSecClassGenericPassword,
            kSecAttrService as NSString: service,
            kSecReturnData as NSString: kCFBooleanTrue!,
            kSecMatchLimit as NSString: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(keychainQuery as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let retrievedData = dataTypeRef as? Data {
            return String(data: retrievedData, encoding: .utf8)
        }
        
        print("Nothing was retrieved from the keychain. Status code \(status)")
        return nil
    }
    
    func update(service: String, data: String) -> Bool {
        if let dataFromString = data.data(using: .utf8, allowLossyConversion: false) {
            let keychainQuery: NSMutableDictionary = [
                kSecClass as NSString: kSecClassGenericPassword,
                kSecAttrService as NSString: service
            ]
            
            let status = SecItemUpdate(keychainQuery as CFDictionary, [kSecValueData as NSString: dataFromString] as CFDictionary)
            return status == errSecSuccess
        }
        return false
    }
    
    func delete(service: String) -> Bool {
        let keychainQuery: NSMutableDictionary = [
            kSecClass as NSString: kSecClassGenericPassword,
            kSecAttrService as NSString: service,
            kSecReturnData as NSString: kCFBooleanTrue!
        ]
        
        let status = SecItemDelete(keychainQuery as CFDictionary)
        return status == errSecSuccess
    }
}
