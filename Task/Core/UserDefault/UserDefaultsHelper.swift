//
//  UserDefaultsHelper.swift
//  Task
//
//  Created by Sahib on 14.04.25.
///



import Foundation

enum UserDefaultsKeys: String {
    case isLoggedIn = "IsLoggedInStatusKey"
}

final class UserDefaultsHelper {
    private init() {} //
    static let defaults = UserDefaults.standard
    
    // MARK: Setters
    
    static func setObject(key: UserDefaultsKeys, value: AnyObject) {
        defaults.setValue(value, forKey: key.rawValue)
        
    }
    
    static func setString(key: UserDefaultsKeys, value: String) {
        defaults.setValue(value, forKey: key.rawValue)
    
    }
    
    static func setInteger(key: UserDefaultsKeys, value: Int) {
        defaults.setValue(value, forKey: key.rawValue)
       
    }
    
    static func setDouble(key: UserDefaultsKeys, value: Double) {
        defaults.setValue(value, forKey: key.rawValue)
        
    }
    
    static func setFloat(key: UserDefaultsKeys, value: Float) {
        defaults.setValue(value, forKey: key.rawValue)
 
    }
    
    static func setBool(key: UserDefaultsKeys, value: Bool) {
        defaults.setValue(value, forKey: key.rawValue)
      
    }
    
    
    // MARK: Getters
    
    static func getObject(key: UserDefaultsKeys) -> AnyObject? {
        return defaults.object(forKey: key.rawValue) as AnyObject?
    }
    
    static func getString(key: UserDefaultsKeys) -> String? {
        return defaults.string(forKey: key.rawValue)
    }
    
    static func getInteger(key: UserDefaultsKeys) -> Int {
        print(defaults.integer(forKey: key.rawValue))
        return defaults.integer(forKey: key.rawValue)
    }
    
    static func getDouble(key: UserDefaultsKeys) -> Double {
        return defaults.double(forKey: key.rawValue)
    }
    
    static func getFloat(key: UserDefaultsKeys) -> Float {
        return defaults.float(forKey: key.rawValue)
    }
    
    static func getBool(key: UserDefaultsKeys) -> Bool {
        return defaults.bool(forKey: key.rawValue)
    }
    
    // MARK: Remover
    
    static func remove(key: UserDefaultsKeys) {
        defaults.removeObject(forKey: key.rawValue)
    }
}
