//
//  LoginController.swift
//  Task
//
//  Created by Sahib on 14.04.25.
//
import UIKit



final class RegisterController: BaseViewController {
    
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let registerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Qeydiyyat"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Ad"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var nameTextField : CustomTextField =  {
        let t = CustomTextField()
        t.delegate = self
        t.placeholder = "Ad girin"
        t.anchorSize(.init(width: 0, height: 44))
        return t
    }()
    
    private let nameErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email:"
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
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Telefon nömrəsi:"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var phoneNumberTextField:CustomTextField =  {
        let t = CustomTextField()
        t.delegate = self
        t.keyboardType = .phonePad
        t.placeholder = "+994xxxxxxxxx"
        t.anchorSize(.init(width: 0, height: 44))
        return t
    }()
    
    private let phoneNumberErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    
    private let birthDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Doğum tarixi:"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var birthDateTextField:  CustomTextField = {
        let t = CustomTextField()
        t.delegate = self
        t.placeholder = "Doğum tarixini seçin"
        t.anchorSize(.init(width: 0, height: 44))
        t.inputView = datePicker
        return t
    }()
    
    private let birthDateErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    
    private let datePicker : UIDatePicker = {
        let d = UIDatePicker()
        d.datePickerMode = .date
        d.maximumDate = Date()
        if #available(iOS 13.4, *) {
            d.preferredDatePickerStyle = .wheels
        }
        return d
    }()
    
    private lazy var registerButton : ResuableButton = {
        let b = ResuableButton()
        b.setTitle("Qeydiyyatdan keçiniz", for: .normal)
        b.anchorSize(.init(width: 0, height: 50))
        return b
    }()
    
    private lazy var loginButton: ResuableButton = {
        let b = ResuableButton()
        b.setTitle("Hesabınız var? Daxil olun", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        b.style = .link
        return b
    }()
    
    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let buttonBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 8
        return view
    }()
    
    private let phoneNumberPrefix = "+994"
    private let viewModel: RegisterViewModel
    private let dateFormatter = DateFormatter()
    private var buttonBackgroundViewBottomConstraint: NSLayoutConstraint?
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        dateFormatter.dateFormat = "dd.MM.yyyy"
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureViewModel()
        configureDatePickerToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotifications()
    }
    
    override func configureView() {
        super.configureView()
        view.addSubViews(scrollView, buttonBackgroundView)
        buttonBackgroundView.addSubview(buttonStackView)
        scrollView.addSubview(contentView)
        contentView.addSubViews(registerTitleLabel, stackView)
    }
    
    
    override func configureConstraint() {
        super.configureConstraint()
        
        scrollView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor
        )
        scrollView.contentInset.bottom = buttonBackgroundView.frame.height
        scrollView.verticalScrollIndicatorInsets.bottom = buttonBackgroundView.frame.height
        
        contentView.anchor(
            top: scrollView.topAnchor,
            leading: scrollView.leadingAnchor,
            bottom: scrollView.bottomAnchor,
            trailing: scrollView.trailingAnchor
        )
        contentView.anchorWidth(to: scrollView)
        
        let heightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true
        
        registerTitleLabel.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 30, left: 16, bottom: 0, right: -16)
        )
        
        stackView.anchor(
            top: registerTitleLabel.bottomAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 30, left: 16, bottom: 0, right: -16)
        )
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true

        stackView.addArrangedSubviews(
            nameLabel,
            nameTextField,
            nameErrorLabel,
            emailLabel,
            emailTextField,
            emailErrorLabel,
            passwordLabel,
            passwordTextField,
            passwordErrorLabel,
            phoneNumberLabel,
            phoneNumberTextField,
            phoneNumberErrorLabel,
            birthDateLabel,
            birthDateTextField,
            birthDateErrorLabel
        )
        
        buttonBackgroundView.anchor(
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            widthGreaterThanOrEqualToConstant: 90
        )
        buttonBackgroundViewBottomConstraint = buttonBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        buttonBackgroundViewBottomConstraint?.isActive = true

        buttonStackView.anchor(
            top: buttonBackgroundView.topAnchor,
            leading: buttonBackgroundView.leadingAnchor,
            bottom: buttonBackgroundView.bottomAnchor,
            trailing: buttonBackgroundView.trailingAnchor,
            padding: .init(top: 20, left: 16, bottom: -20, right: -16)
        )
        
        buttonStackView.addArrangedSubviews(registerButton, loginButton)
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
                    showMessage(title: "xəta",message: error)
            }
        }
        
        viewModel.validationUpdateHandler = { [weak self] (type, isValid) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                let defaultColor = UIColor.lightGray.cgColor
                let errorColor = UIColor.red.cgColor
                
                let field: CustomTextField
                let label: UILabel
                let value: String?
                
                switch type {
                    case .email:
                        field = self.emailTextField
                        label = self.emailErrorLabel
                        value = self.emailTextField.text
                    case .password:
                        field = self.passwordTextField
                        label = self.passwordErrorLabel
                        value = self.passwordTextField.text
                    case .name:
                        field = self.nameTextField
                        label = self.nameErrorLabel
                        value = self.nameTextField.text
                    case .phoneNumber:
                        field = self.phoneNumberTextField
                        label = self.phoneNumberErrorLabel
                        value = self.phoneNumberTextField.text
                    case .birthDate:
                        field = self.birthDateTextField
                        label = self.birthDateErrorLabel
                        value = self.birthDateTextField.text
                }
                
                field.layer.borderColor = isValid ? defaultColor : errorColor
                label.text = isValid ? nil : type.errorMessage(for: value ?? "")
                label.isHidden = isValid
            }
        }
    }
    
    private func configureDatePickerToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "İptal", style: .plain, target: self, action: #selector(cancelDatePicker))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Tamam", style: .done, target: self, action: #selector(doneDatePicker))
        toolbar.setItems([cancelButton, flexSpace, doneButton], animated: false)
        birthDateTextField.inputAccessoryView = toolbar
    }
    
    @objc private func registerBtnClicked() {
        view.endEditing(true)
        let errors = viewModel.validateRegisterCredentials()
        
        
        updateErrorLabel(for: .name, errors: errors)
        updateErrorLabel(for: .email, errors: errors)
        updateErrorLabel(for: .password, errors: errors)
        updateErrorLabel(for: .phoneNumber, errors: errors)
        updateErrorLabel(for: .birthDate, errors: errors)
        
        if errors.isEmpty {
            viewModel.registerRequest()
        } else {
            let errorMessage = errors.joined(separator: "\n")
            showMessage(title: "Qeydiyyat ugursuz", message: errorMessage)
        }
    }
    
    @objc private func loginBtnClicked() {
        
        print("login button tapped")
        viewModel.showLogin()
    }
    
    @objc private func cancelDatePicker() {
        birthDateTextField.resignFirstResponder()
    }
    
    @objc private func doneDatePicker() {
        let selectedDate = datePicker.date
        birthDateTextField.text = dateFormatter.string(from: selectedDate)
        viewModel.updateBirthDate(selectedDate)
        birthDateTextField.resignFirstResponder()
    }
    
    
    private func updateErrorLabel(for type: ValidationTypeRegister, errors: [String]) {
        let specificError = errors.first { $0.lowercased().contains(type.errorKeyword) }
        
        let mapping: (UILabel, CustomTextField) = {
            switch type {
                case .email: return (emailErrorLabel, emailTextField)
                case .password: return (passwordErrorLabel, passwordTextField)
                case .name:
                    return (nameErrorLabel, nameTextField)
                case .phoneNumber:
                    return (phoneNumberErrorLabel, phoneNumberTextField)
                case .birthDate:
                    return (birthDateErrorLabel, birthDateTextField)
            }
        }()
        
        DispatchQueue.main.async {
            let (label, field) = mapping
            label.text = specificError
            label.isHidden = (specificError == nil)
            field.layer.borderColor = (specificError == nil) ? UIColor.lightGray.cgColor : UIColor.red.cgColor
        }
    }
    
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let keyboardHeight = keyboardFrame.height
        buttonBackgroundViewBottomConstraint?.constant = -keyboardHeight
        let totalBottom = keyboardHeight + buttonBackgroundView.frame.height
        scrollView.contentInset.bottom = totalBottom
        scrollView.verticalScrollIndicatorInsets.bottom = totalBottom
        UIView.animate(withDuration: keyboardAnimationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3
        buttonBackgroundViewBottomConstraint?.constant = 0
        scrollView.contentInset.bottom = buttonBackgroundView.frame.height
        scrollView.verticalScrollIndicatorInsets.bottom = buttonBackgroundView.frame.height
        UIView.animate(withDuration: keyboardAnimationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}

extension RegisterController: UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == phoneNumberTextField {
            if textField.text?.isEmpty ?? true || !(textField.text?.hasPrefix(phoneNumberPrefix) ?? false) {
                textField.text = phoneNumberPrefix
                
                viewModel.updateText(textField.text, for: .phoneNumber)
            }
        }
        
        if textField == birthDateTextField {
            textField.placeholder = "Tarix seçiliyor..."
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == birthDateTextField {
            if textField.text?.isEmpty ?? true {
                textField.placeholder = "Doğum tarixinizi seçin"
            }
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == birthDateTextField {
            return false
        }
        if textField == phoneNumberTextField {
            guard let currentText = textField.text, let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            if !updatedText.isEmpty && !updatedText.hasPrefix(phoneNumberPrefix) { return false }
            if updatedText == phoneNumberPrefix { return true }
            let charactersAfterPrefix = updatedText.dropFirst(phoneNumberPrefix.count)
            if !charactersAfterPrefix.allSatisfy({ $0.isNumber }) { return false }
            let maxLength = phoneNumberPrefix.count + 9
            return updatedText.count <= maxLength
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField == nameTextField {
            viewModel.updateText(textField.text, for: .name)
        } else if textField == emailTextField {
            viewModel.updateText(textField.text, for: .email)
        }
        else if textField == passwordTextField {
            viewModel.updateText(textField.text, for: .password)
        }
        else if textField == phoneNumberTextField {
            viewModel.updateText(textField.text, for: .phoneNumber)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case nameTextField: passwordTextField.becomeFirstResponder()
            case emailTextField: passwordTextField.becomeFirstResponder()
            case passwordTextField: phoneNumberTextField.becomeFirstResponder()
            case phoneNumberTextField: birthDateTextField.becomeFirstResponder()
            case birthDateTextField: birthDateTextField.resignFirstResponder()
            default: textField.resignFirstResponder()
        }
        return true
    }
}
