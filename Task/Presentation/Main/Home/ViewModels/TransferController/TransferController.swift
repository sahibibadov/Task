//
//  TransferController.swift
//  Task
//
//  Created by Sahib on 14.04.25.
//

import UIKit

private enum PickerType: Int {
    case from = 1
    case to = 2
}

final class TransferController: BaseViewController {
    
    // MARK: - Properties
    
    private var viewModel: TransferViewModel
    
    // MARK: - UI Components
    
    private lazy var fromLabel = createSectionLabel(text: "Göndərən Hesab:")
    private lazy var toLabel = createSectionLabel(text: "Alan Hesab:")
    private lazy var amountLabel = createSectionLabel(text: "Məbləğ:")
    
    private lazy var fromAccountPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.tag = PickerType.from.rawValue
        picker.selectRow(0, inComponent: 0, animated: false)
        return picker
    }()
    
    private lazy var toAccountPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.tag = PickerType.to.rawValue
        picker.selectRow(0, inComponent: 0, animated: false)
        return picker
    }()
    
    private lazy var amountTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "0.00"
        textField.keyboardType = .decimalPad
        textField.anchorSize(.init(width: 0, height: 44))
        textField.delegate = self
        return textField
    }()
    
    private lazy var transferButton: ResuableButton = {
        let button = ResuableButton()
        button.setTitle("Köçürmə Et", for: .normal)
        return button
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fill
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Initialization
    
    init(viewModel: TransferViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureViewModel()
        setupGestureRecognizers()
    }
    
    
    override func configureView() {
        super.configureView()
        view.addSubview(stackView)
        stackView.addArrangedSubviews(
            fromLabel,
            fromAccountPicker,
            toLabel,
            toAccountPicker,
            amountLabel,
            amountTextField,
            errorLabel,
            transferButton
        )
    }
    
    override func configureConstraint() {
        super.configureConstraint()
        stackView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: -20)
        )

        fromAccountPicker.anchorSize(.init(width: 0, height: 100))
        toAccountPicker.anchorSize(.init(width: 0, height: 100))
        amountTextField.anchorSize(.init(width: 0, height: 44))
        transferButton.anchorSize(.init(width: 0, height: 44))
    }
    
    override func configureTargets() {
        super.configureTargets()
        transferButton.addTarget(self, action: #selector(transferButtonTapped), for: .touchUpInside)
    }
    
    private func configureViewModel() {
        viewModel.onValidationError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.errorLabel.text = errorMessage
                self?.errorLabel.isHidden = (errorMessage == nil)
                self?.updateTextFieldBorder(hasError: errorMessage != nil)
            }
        }
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func createSectionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 16)
        return label
    }
    
    private func updateTextFieldBorder(hasError: Bool) {
        amountTextField.layer.borderColor = hasError ? UIColor.systemRed.cgColor : UIColor.clear.cgColor
        amountTextField.layer.borderWidth = hasError ? 1 : 0
        amountTextField.layer.cornerRadius = hasError ? 5 : 0
    }
    
    
    @objc private func transferButtonTapped() {
        dismissKeyboard()
        if viewModel.validateAndPrepareTransfer() {
            viewModel.completeTransfer()
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension TransferController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.getCardsCount()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.getCardNumber(index: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let pickerType = PickerType(rawValue: pickerView.tag) else { return }
        
        switch pickerType {
            case .from:
                viewModel.selectFromCard(at: row)
            case .to:
                viewModel.selectToCard(at: row)
        }
    }
}


extension TransferController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == amountTextField {
            viewModel.setAmount(textField.text)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == amountTextField else { return true }
        
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        return validateAmountInput(currentText: currentText,
                                   prospectiveText: prospectiveText,
                                   replacementString: string)
    }
    
    private func validateAmountInput(currentText: String,
                                     prospectiveText: String,
                                     replacementString string: String) -> Bool {
        
        if string.isEmpty { return true }
        
        let decimalSeparator = Locale.current.decimalSeparator ?? "."
        let allowedCharacters = CharacterSet(charactersIn: "0123456789").union(CharacterSet(charactersIn: decimalSeparator))
        
        if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            return false
        }
        
        let separatorCount = prospectiveText.components(separatedBy: decimalSeparator).count - 1
        if separatorCount > 1 {
            return false
        }
        
        if currentText == "0" && string != decimalSeparator && !string.isEmpty {
            amountTextField.text = string
            viewModel.setAmount(string)
            return false
        }
        
        if currentText.isEmpty && string == decimalSeparator {
            amountTextField.text = "0" + decimalSeparator
            viewModel.setAmount(amountTextField.text)
            return false
        }
        
        if let separatorIndex = prospectiveText.firstIndex(of: Character(decimalSeparator)) {
            let fractionPart = prospectiveText.suffix(from: prospectiveText.index(after: separatorIndex))
            if fractionPart.count > 2 {
                return false
            }
        }
        return true
    }
}

