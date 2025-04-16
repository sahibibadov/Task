//
//  CardModel.swift
//  Task
//
//  Created by Sahib on 14.04.25.
//

import Foundation

struct CardModel: Equatable {
    var cardNumber: String
    var amount: Double
    var date: String 
    var cardType: CardType
    
    enum CardType {
        case visa
        case mastercard
        case americanExpress
        case other
        var displayName: String {
            switch self {
                case .visa: return "Visa"
                case .mastercard: return "Mastercard"
                case .americanExpress: return "American Express"
                case .other: return "Diğer"
            }
        }
    }
    
    var maskedCardNumber: String {
        guard cardNumber.count >= 4 else { return cardNumber }
        let lastFour = String(cardNumber.suffix(4))
        return "•••• •••• •••• \(lastFour)"
    }
    
    
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "azn"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "azn\(amount)"
    }
    
    static func == (lhs: CardModel, rhs: CardModel) -> Bool {
        return lhs.cardNumber == rhs.cardNumber
    }
}
