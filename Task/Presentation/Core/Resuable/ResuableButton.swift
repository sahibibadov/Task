//
//  ResuableButton.swift
//  Task
//
//  Created by Sahib on 15.04.25.
//

import UIKit

class ResuableButton: UIButton {
    
    // MARK: - Properties
    
    enum ButtonStyle {
        case primary
        case secondary
        case danger
        case link
        case custom(normalColor: UIColor, highlightedColor: UIColor, disabledColor: UIColor)
    }
    
    var style: ButtonStyle = .primary {
        didSet {
            configureButton()
        }
    }
    
    var cornerRadius: CGFloat = 8.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    var title: String? {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    
    var fontSize: CGFloat = 16.0 {
        didSet {
            titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        // Default configuration
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        
        configureButton()
    }
    
    // MARK: - Configuration
    
    private func configureButton() {
        switch style {
            case .primary:
                setColors(normal: .systemBlue, highlighted: .systemBlue.withAlphaComponent(0.8), disabled: .lightGray)
                setTitleColor(.white, for: .normal)
            case .secondary:
                setColors(normal: .systemGray5, highlighted: .systemGray4, disabled: .systemGray6)
                setTitleColor(.darkGray, for: .normal)
            case .danger:
                setColors(normal: .systemRed, highlighted: .systemRed.withAlphaComponent(0.8), disabled: .systemGray)
                setTitleColor(.white, for: .normal)
            case .link:
                setColors(
                    normal: .clear,
                    highlighted: .clear,
                    disabled: .clear
                )
                setTitleColor(.systemBlue, for: .normal)
            case .custom(let normalColor, let highlightedColor, let disabledColor):
                setColors(normal: normalColor, highlighted: highlightedColor, disabled: disabledColor)
        }
    }
    
    private func setColors(normal: UIColor, highlighted: UIColor, disabled: UIColor) {
        setBackgroundImage(UIImage(color: normal), for: .normal)
        setBackgroundImage(UIImage(color: highlighted), for: .highlighted)
        setBackgroundImage(UIImage(color: disabled), for: .disabled)
    }
    
    // MARK: - Layout
    
    override var intrinsicContentSize: CGSize {
        let originalSize = super.intrinsicContentSize
        return CGSize(width: originalSize.width + 32, height: originalSize.height + 16)
    }
    
    // MARK: - Touch Animations
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animateScale(scale: 0.96)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animateScale(scale: 1.0)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animateScale(scale: 1.0)
    }
    
    private func animateScale(scale: CGFloat) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.transform = scale == 1.0 ? .identity : CGAffineTransform(scaleX: scale, y: scale)
        })
    }
}

// Helper extension to create UIImage from UIColor
extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
