//
//  CardManager.swift
//  Task
//
//  Created by Sahib on 14.04.25.
//

import Foundation

final class CardManager {
    static let shared = CardManager()
    
    private(set) var cards: [CardModel] = [
        CardModel(cardNumber: "1234567890123456", amount: 10.0, date: "05/25", cardType: .visa),
    ]
    
    private init() {}
    
    func addRandomCard() {
        let cardTypes: [CardModel.CardType] = [.visa, .mastercard, .americanExpress]
        let randomType = cardTypes.randomElement() ?? .visa
        
        let randomCardNumber = (0..<16).map { _ in "\(Int.random(in: 0...9))" }.joined()
        let randomAmount = 10.0
        
        let currentYear = Calendar.current.component(.year, from: Date()) % 100
        let randomMonth = String(format: "%02d", Int.random(in: 1...12))
        let randomYear = String(format: "%02d", Int.random(in: currentYear...currentYear+5))
        
        let newCard = CardModel(
            cardNumber: randomCardNumber,
            amount: randomAmount,
            date: "\(randomMonth)/\(randomYear)",
            cardType: randomType
        )
        
        cards.append(newCard)
        NotificationCenter.default.post(name: .cardsDidUpdate, object: nil)
    }
    
    func removeLastCard() -> Bool {
        guard !cards.isEmpty else { return false }
        cards.removeLast()
        NotificationCenter.default.post(name: .cardsDidUpdate, object: nil)
        return true
    }
    
    func makeTransfer(amount: Double, fromCardIndex: Int, toCardIndex: Int) -> Bool {
        guard fromCardIndex < cards.count else { return false }
        guard toCardIndex < cards.count else { return false }
        
        guard amount > 0 && amount <= cards[fromCardIndex].amount else { return false }
        
        
        cards[fromCardIndex].amount -= amount
        cards[toCardIndex].amount += amount
        
        
        NotificationCenter.default.post(name: .cardsDidUpdate, object: nil)
        return true
    }
}

extension Notification.Name {
    static let cardsDidUpdate = Notification.Name("cardsDidUpdate")
}
