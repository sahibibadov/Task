//
//  CustomTextField.swift
//  Task
//
//  Created by Sahib on 14.04.25.
//

import UIKit

class CustomTextField: UITextField {

    // Colors for different states
    var normalBorderColor: UIColor = .lightGray {
        didSet {
            layer.borderColor = normalBorderColor.cgColor
        }
    }
    var focusedBorderColor: UIColor = .systemBlue
    var errorBorderColor: UIColor = .systemRed
    
    // Border width
    var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    // Corner radius
    var cornerRadius: CGFloat = 8.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    // Padding for text
    private let padding = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
    
    // Error state
    var hasError: Bool = false {
        didSet {
            updateBorderColor()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        // Basic styling
        backgroundColor = .white
        
        // Border setup
        layer.borderWidth = borderWidth
        layer.borderColor = normalBorderColor.cgColor
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        // Add targets for editing events
        addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
    }
    
    @objc private func editingDidBegin() {
        updateBorderColor()
    }
    
    @objc private func editingDidEnd() {
        updateBorderColor()
    }
    
    private func updateBorderColor() {
        if hasError {
            layer.borderColor = errorBorderColor.cgColor
        } else if isEditing {
            layer.borderColor = focusedBorderColor.cgColor
        } else {
            layer.borderColor = normalBorderColor.cgColor
        }
    }
    
    // Text padding
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
