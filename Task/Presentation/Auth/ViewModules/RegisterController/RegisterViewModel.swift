//
//  RegisterViewModel.swift
//  Task
//
//  Created by Sahib on 14.04.25.
//
import Foundation

enum ValidationTypeRegister {
    case name
    case email
    case password
    case phoneNumber
    case birthDate
    
    var errorKeyword: String {
        switch self {
            case .email: return "email"
            case .password: return "şifrə"
            case .name: return "ad"
            case .phoneNumber: return "telefon"
            case .birthDate: return "doğum tarixi"
        }
    }
    
    func errorMessage(for value: String) -> String {
        switch self {
            case .email:
                return value.isEmpty ? "Email alanı boş buraxılamaz." : "Geçərsiz email formatı."
            case .password:
                return value.isEmpty ? "Şifrə alanı boş buraxılamaz." : "Şifrə ən az 6 simvol olmalıdır."
            case .name:
                return value.isEmpty ? "Ad alanı boş buraxılamaz." : "Ad ən az 2 simvol olmalıdır."
            case .phoneNumber:
                return value.isEmpty ? "telefon  nömrəsi boş buraxılamaz." : "Geçərsiz telefon nömrəsi formatı (+994xxxxxxxxx)."
            case .birthDate:
                return value.isEmpty ? "Doğum tarixi seçilməlidir.." : ""
        }
        
    }
    
}

final class RegisterViewModel {
    enum ViewState {
        
        case success
        case error(String)
    }
    
    var nameText: String?
    var emailText: String?
    var passwordText: String?
    var phoneNumberText: String?
    var birthDate: Date?
    
    private(set) var isNameCurrentlyValid: Bool = false
    private(set) var isEmailCurrentlyValid: Bool = false
    private(set) var isPasswordCurrentlyValid: Bool = false
    private(set) var isPhoneNumberCurrentlyValid: Bool = false
    private(set) var isBirthDateSelected: Bool = false
    
    var validationUpdateHandler: ((ValidationTypeRegister, Bool) -> Void)?
    
    private  weak var navigation: AuthNavigation?
    private let authManager: AuthKeychainManagerProtocol
    var callBack : ((ViewState)-> Void)?
    
    init(navigation: AuthNavigation, authManager: AuthKeychainManagerProtocol) {
        self.navigation = navigation
        self.authManager = authManager
    }
    
    func updateText(_ text: String?, for type: ValidationTypeRegister) {
        let currentText = text ?? ""
        var isValid = false
        switch type {
            case .name:
                self.nameText = currentText
                isValid = currentText.isNameValid()
                self.isNameCurrentlyValid = isValid
            case .email:
                self.emailText = currentText
                isValid = currentText.isEmailValid()
                self.isEmailCurrentlyValid = isValid
            case .password:
                self.passwordText = currentText
                isValid = currentText.isPasswordValid()
                self.isPasswordCurrentlyValid = isValid
            case .phoneNumber:
                self.phoneNumberText = currentText
                isValid = currentText.isPhoneNumberValid()
                self.isPhoneNumberCurrentlyValid = isValid
            case .birthDate:
                break
        }
        
        if type != .birthDate {
            validationUpdateHandler?(type, isValid)
        }
    }
    
    private func checkBirthDateSelected(_ date: Date?) -> Bool {
        return date != nil
    }
    
    func updateBirthDate(_ date: Date?) {
        self.birthDate = date
        let isSelected = checkBirthDateSelected(date)
        var isOfAge = false
        if let birthDate = date {
            let calendar = Calendar.current
            let now = Date()
            if let age = calendar.dateComponents([.year], from: birthDate, to: now).year, age >= 18 {
                isOfAge = true
            } else {
                callBack?(.error("18 yaşdan kiçik istifadəçi qeydiyyatdan keçə bilməz"))
            }
        }
        self.isBirthDateSelected = isSelected && isOfAge
        validationUpdateHandler?(.birthDate, self.isBirthDateSelected)
    }
    
    func validateRegisterCredentials() -> [String] {
        var errors: [String] = []
        
        let validations: [(ValidationTypeRegister, String?, Bool)] = [
            (.email, emailText, isEmailCurrentlyValid),
            (.password, passwordText, isPasswordCurrentlyValid),
            (.name,  nameText, isNameCurrentlyValid),
            (.phoneNumber,  phoneNumberText, isPhoneNumberCurrentlyValid),
            (.birthDate,  nil, isBirthDateSelected),
        ]
        
        for (type, value, isValid) in validations {
            if !isValid {
                errors.append(type.errorMessage(for: value ?? ""))
            }
        }
        
        return errors
    }
    
    
    
    func showLogin (){
        navigation?.showLogin()
    }
    
    func registerRequest (){
        guard let nameText,let passwordText,let emailText,let phoneNumberText,let birthDate else {return}
        let user = User(
            name: nameText,
            email: emailText,
            password: passwordText,
            phoneNumber: phoneNumberText,
            birthDate: birthDate
        )
        
        guard !authManager.isEmailRegistered(emailText) else {
            callBack?(.error("Email artiq movcuddur"))
            return
        }
        
        if authManager.saveUser(user) {
            navigation?.showLogin()
        }
    }
}
