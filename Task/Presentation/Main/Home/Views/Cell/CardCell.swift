//
//  CardCell.swift
//  Task
//
//  Created by Sahib on 14.04.25.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    private let cardContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cardNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cardTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let topStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    private let bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        return stack
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        contentView.addSubview(cardContainer)
        stackView.addArrangedSubviews(topStack, bottomStack)
        topStack.addArrangedSubviews(cardNumberLabel, amountLabel)
        bottomStack.addArrangedSubviews(dateLabel, cardTypeLabel)
        
        cardContainer.addSubview(stackView)
        
        cardContainer.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 8, left: 16, bottom: -8, right: -16)
        )
        
        
        stackView.anchor(
            top: cardContainer.topAnchor,
            leading: cardContainer.leadingAnchor,
            bottom: cardContainer.bottomAnchor,
            trailing: cardContainer.trailingAnchor,
            padding: UIEdgeInsets(top: 16, left: 16, bottom: -8, right: -16)
        )
        
    }
    
    func configure(with card: CardModel) {
        cardNumberLabel.text = card.maskedCardNumber
        amountLabel.text = card.formattedAmount
        dateLabel.text = "Bitmə tarixi: \(card.date)"
        cardTypeLabel.text = card.cardType.displayName
        
        
        switch card.cardType {
            case .visa:
                cardContainer.backgroundColor = UIColor(hex: "#1A1F71").withAlphaComponent(0.4)
                cardNumberLabel.textColor = .white
                amountLabel.textColor = .white
            case .mastercard:
                cardContainer.backgroundColor = UIColor(hex: "#EB001B").withAlphaComponent(0.4)
                cardNumberLabel.textColor = .white
                amountLabel.textColor = .white
            case .americanExpress:
                cardContainer.backgroundColor = UIColor(hex: "#007CC3").withAlphaComponent(0.4)
                cardNumberLabel.textColor = .white
                amountLabel.textColor = .white
            case .other:
                cardContainer.backgroundColor = .systemGray5
                cardNumberLabel.textColor = .label
                amountLabel.textColor = .label
        }
    }
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
            case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
