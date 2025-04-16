//
//  loginViewModel.swift
//  Task
//
//  Created by Sahib on 14.04.25.
//

import Foundation

enum ValidationTypeLogin {
    case email
    case password
    
    var errorKeyword: String {
        switch self {
            case .email: return "email"
            case .password: return "şifrə"
        }
    }
    
    func errorMessage(for value: String) -> String {
        switch self {
            case .email:
                return value.isEmpty ? "Email alanı boş buraxılamaz." : "Geçərsiz email formatı."
            case .password:
                return value.isEmpty ? "Şifrə alanı boş buraxılamaz." : "Şifrə ən az 6 simvol olmalıdır."
        }
    }
}

final class LoginViewModel {
    enum ViewState {
        case success
        case error(String)
    }
    
    var emailText: String?
    var passwordText: String?
    
    private(set) var isEmailCurrentlyValid: Bool = false
    private(set) var isPasswordCurrentlyValid: Bool = false
    
    var validationUpdateHandler: ((ValidationTypeLogin, Bool) -> Void)?
    var callBack: ((ViewState) -> Void)?
    private let authManager: AuthKeychainManagerProtocol
    private  weak var navigation: AuthNavigation?
    
    init(navigation: AuthNavigation,authManager: AuthKeychainManagerProtocol = AuthKeychainManager()) {
        self.navigation = navigation
        self.authManager = authManager
    }
    
    func updateText(_ text: String?, for type: ValidationTypeLogin) {
        let currentText = text ?? ""
        var isValid = false
        
        switch type {
            case .email:
                self.emailText = currentText
                isValid = currentText.isEmailValid()
                self.isEmailCurrentlyValid = isValid
            case .password:
                self.passwordText = currentText
                isValid = currentText.isPasswordValid()
                self.isPasswordCurrentlyValid = isValid
                
        }
        validationUpdateHandler?(type, isValid)
    }
    
    func validateLoginCredentials() -> [String] {
        var errors: [String] = []
        
        let validations: [(ValidationTypeLogin, String?, Bool)] = [
            (.email, emailText, isEmailCurrentlyValid),
            (.password, passwordText, isPasswordCurrentlyValid)
        ]
        
        for (type, value, isValid) in validations {
            if !isValid {
                errors.append(type.errorMessage(for: value ?? ""))
            }
        }
        
        return errors
    }
    
    
    func showRegister (){
        navigation?.showRegister()
    }
    
    func loginRequest (){
        guard let passwordText,let emailText else {return}
        guard let user = authManager.getUser() else {
            callBack?(.error("İstifadəci tapilmadı, xahiş olunur qeydiyyatdan keçiniz."))
            return
        }
        guard user.email == emailText else {
            callBack?(.error("Email səhfdir"))
            return
        }
        guard user.password == passwordText else {
            callBack?(.error("password səhfdir"))
            return
        }
        navigation?.showHome()
    }
}

