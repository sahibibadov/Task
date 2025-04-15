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
           case .phoneNumber: // Telefon numarası durumu eklendi
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
           self.isBirthDateSelected = isSelected
          
           validationUpdateHandler?(.birthDate, isSelected)
       }
    
    func validateRegisterCredentials() -> [String] {
               var errors: [String] = []

            if !isNameCurrentlyValid {
                if (nameText ?? "").isEmpty { errors.append("Ad alanı boş buraxılamaz.") }
                else { errors.append("Ad en az 2 karakter olmalıdır.") }
            }
            
             
               if !isEmailCurrentlyValid {
                    if (emailText ?? "").isEmpty { errors.append("Email alanı boş buraxılamaz.") }
                    else { errors.append("Geçərsiz email adresi formatı.") }
               }

              
               if !isPasswordCurrentlyValid {
                   if (passwordText ?? "").isEmpty { errors.append("Şifrə alanı boş buraxılamaz.") }
                   else { errors.append("Şifrə ən az 6 karakter olmalıdır.") }
               }

             
               if !isPhoneNumberCurrentlyValid {
                    if (phoneNumberText ?? "").isEmpty {
                        errors.append("Telefon nömrəsi alanı boş buraxılamaz.")
                    } else {
                      
                        errors.append("Geçərsiz telefon nömrəsi formatı (+994xxxxxxxxx).")
                    }
               }
            
                    if !isBirthDateSelected {
                        errors.append("Doğum tarixi seçilməlidir.")
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
