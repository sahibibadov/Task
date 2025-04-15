//
//  LoginController.swift
//  Task
//
//  Created by Sahib on 14.04.25.
//


import UIKit

final class LoginController: BaseViewController {

   
    private let stackView: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 8
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

 
    private let loginTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Daxil olun"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var emailTextField : CustomTextField =  {
        let t = CustomTextField()
        t.delegate = self
        t.keyboardType = .emailAddress
        t.placeholder = "Email adresini giriniz"
        t.anchorSize(.init(width: 0, height: 44))
        return t
    }()
    
    private let emailErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    // --- Şifre ---
    private let passwordLabel: UILabel = {
            let label = UILabel()
            label.text = "Şifrə:"
            label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            return label
        }()

    private lazy var passwordTextField : CustomTextField =  {
        let t = CustomTextField()
        t.delegate = self
        t.isSecureTextEntry = true
        t.placeholder = "Şifrənizi girin"
        t.anchorSize(.init(width: 0, height: 44))
        return t
    }()
    
    private let passwordErrorLabel: UILabel = {
           let label = UILabel()
           label.textColor = .systemRed
           label.font = UIFont.systemFont(ofSize: 13)
           label.numberOfLines = 0
           label.isHidden = true
           return label
       }()

    private lazy var loginButton: ResuableButton = {
        let b = ResuableButton()
        b.setTitle("Daxil olun", for: .normal)
        b.anchorSize(.init(width: 0, height: 50))
        return b
    }()
    
    private lazy var registerButton: ResuableButton = {
        let b = ResuableButton()
        b.setTitle("Hesabınız yoxdur? Qeydiyyatdan keçin", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        b.style = .link
        return b
    }()
    
    private let buttonStackView: UIStackView = { 
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()

    private let viewModel: LoginViewModel
   
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
     
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureViewModel()
       }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            clearTextFields()
        }

    
    override func configureView() {
        super.configureView()
        view.addSubViews(loginTitleLabel, stackView)

     
        buttonStackView.addArrangedSubviews(loginButton, registerButton)

     
        stackView.addArrangedSubviews(
            emailLabel,
            emailTextField,
            emailErrorLabel,
            passwordLabel,
            passwordTextField,
            passwordErrorLabel,
            UIView(),
            buttonStackView
        )

    }

    override func configureConstraint() {
        super.configureConstraint()
      
        loginTitleLabel.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 20, left: 16, bottom: 0, right: -16)
        )
        
        stackView.anchor(
            top: loginTitleLabel.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 30, left: 16, bottom: -10, right: -16)
        )
        
    }


    override func configureTargets() {
        super.configureTargets()
        loginButton.addTarget(self, action: #selector(loginBtnClicked), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerBtnClicked), for: .touchUpInside)
    }

 
    private func configureViewModel() {
        viewModel.callBack = { [weak self] state in
            guard let self = self else { return }
            switch state {
                case .success:
                    print("")
                case .error(let error):
                    showMessage(title: "xeta",message: error)
            }
        }
        
      
        viewModel.validationUpdateHandler = { [weak self] (type, isValid) in
            guard let self = self else { return }
             print("Validation Update Received: Type=\(type), isValid=\(isValid)")

            DispatchQueue.main.async {
                let defaultBorderColor = UIColor.lightGray.cgColor
                let errorBorderColor = UIColor.red.cgColor

                var textFieldToUpdate: CustomTextField?
                var errorLabelToUpdate: UILabel?
                var errorMessage: String?
                // MARK: TODO

                switch type {
                  
                    case .email:
                    textFieldToUpdate = self.emailTextField
                    errorLabelToUpdate = self.emailErrorLabel
                    if !isValid { errorMessage = (self.emailTextField.text ?? "").isEmpty ? "Email alanı boş buraxılamaz." : "Geçərsiz email formatı." }
                    case .password:
                    textFieldToUpdate = self.passwordTextField
                    errorLabelToUpdate = self.passwordErrorLabel
                    if !isValid { errorMessage = (self.passwordTextField.text ?? "").isEmpty ? "Şifrə alanı boş buraxılamaz." : "Şifrə ən az 6 karakter olmalıdır." }
                
                }

             
                textFieldToUpdate?.layer.borderColor = isValid ? defaultBorderColor : errorBorderColor
                    
                

                errorLabelToUpdate?.text = errorMessage
                errorLabelToUpdate?.isHidden = isValid
            }
        }
    }

    

   
    @objc private func loginBtnClicked() {
        view.endEditing(true)
        let errors = viewModel.validateLoginCredentials()

        updateErrorLabel(for: .email, errors: errors)
        updateErrorLabel(for: .password, errors: errors)
 
        if errors.isEmpty {
             viewModel.loginRequest()
        } else {
            let errorMessage = errors.joined(separator: "\n")
            showMessage(title: "Login Başarısız", message: errorMessage)
        }
    }

    @objc private func registerBtnClicked() {
        viewModel.showRegister()
    }

    private func clearTextFields() {
            emailTextField.text = ""
            passwordTextField.text = ""
        }

    private func updateErrorLabel(for type: ValidationTypeLogin, errors: [String]) {
     
        var errorLabel: UILabel?
        var textField: CustomTextField?
        var errorKeyword: String = ""
      

        switch type {
           
        case .email:
            errorLabel = emailErrorLabel; textField = emailTextField; errorKeyword = "email"
        case .password:
            errorLabel = passwordErrorLabel; textField = passwordTextField; errorKeyword = "şifrə"
       
        }

        let specificError = errors.first(where: { $0.lowercased().contains(errorKeyword) })
        DispatchQueue.main.async {
            errorLabel?.text = specificError
            errorLabel?.isHidden = (specificError == nil)

          
                 textField?.layer.borderColor = (specificError == nil) ? UIColor.lightGray.cgColor : UIColor.red.cgColor
           
        }
    }

  
}

extension LoginController: UITextFieldDelegate {


    func textFieldDidChangeSelection(_ textField: UITextField) {
     
        if textField == emailTextField {
            viewModel.updateText(textField.text, for: .email)
        }
        else if textField == passwordTextField {
            viewModel.updateText(textField.text, for: .password)
        }
    }

  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField: passwordTextField.becomeFirstResponder()
        case passwordTextField: passwordTextField.resignFirstResponder()
        default: textField.resignFirstResponder()
        }
        return true
    }
}
