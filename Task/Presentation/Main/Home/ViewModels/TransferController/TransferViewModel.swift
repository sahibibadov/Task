//
//  TransferViewModel.swift
//  Task
//
//  Created by Sahib on 14.04.25.
//
import Foundation



final class TransferViewModel {
    
    // MARK: - Properties
    weak var navigation: HomeNavigation?
    
    private var cards: [CardModel]
    private(set) var selectedFromAccount: CardModel?
    private(set) var selectedToAccount: CardModel?
    private(set) var transferAmountString: String?
    
    var onValidationError: ((String?) -> Void)?
    
    private var cardManager = CardManager.shared
    
    init(navigation: HomeNavigation, cards: [CardModel]) {
        self.navigation = navigation
        self.cards = cards
        if !cards.isEmpty {
            self.selectedFromAccount = cards[0]
            self.selectedToAccount = cards[0]
            
        }
    }
    
    
    func selectFromCard(at index: Int) {
        guard index >= 0 && index < cards.count else { return }
        selectedFromAccount = cards[index]
        clearValidationError()
    }
    
    func selectToCard(at index: Int) {
        guard index >= 0 && index < cards.count else { return }
        selectedToAccount = cards[index]
        clearValidationError()
    }
    
    
    func setAmount(_ amountString: String?) {
        self.transferAmountString = amountString
        clearValidationError()
    }
    
    
    func getCardsCount() -> Int {
        return cards.count
    }
    
    func getCardNumber(index: Int) -> String {
        guard index >= 0 && index < cards.count else { return "" }
        return cards[index].cardNumber
    }
    
    func validateAndPrepareTransfer() -> Bool {
        guard validateFromAccount(),
              validateToAccount(),
              validateDifferentAccounts(),
              validateAmount(),
              validatePositiveAmount(),
              validateSufficientBalance() else {
            return false
        }
        
        print("Transfer is ready: \(transferAmountString ?? "") from \(selectedFromAccount?.cardNumber ?? "") to \(selectedToAccount?.cardNumber ?? "")")
        return true
    }
    
    
    private func clearValidationError() {
        onValidationError?(nil)
    }
    
    private func validateFromAccount() -> Bool {
        guard selectedFromAccount != nil else {
            onValidationError?("Göndərən hesab seçilməyib.")
            return false
        }
        return true
    }
    
    private func validateToAccount() -> Bool {
        guard selectedToAccount != nil else {
            onValidationError?("Alan hesab seçilməyib.")
            return false
        }
        return true
    }
    
    private func validateDifferentAccounts() -> Bool {
        guard selectedFromAccount?.cardNumber != selectedToAccount?.cardNumber else {
            onValidationError?("Göndərən və alan hesab eyni ola bilməz.")
            return false
        }
        return true
    }
    
    private func validateAmount() -> Bool {
        guard let amountStr = transferAmountString, !amountStr.isEmpty, Double(amountStr) != nil else {
            onValidationError?("Məbləğ düzgün daxil edilməyib.")
            return false
        }
        return true
    }
    
    private func validatePositiveAmount() -> Bool {
        guard let amountStr = transferAmountString, let amount = Double(amountStr), amount > 0 else {
            onValidationError?("Məbləğ 0-dan böyük olmalıdır.")
            return false
        }
        return true
    }
    
    private func validateSufficientBalance() -> Bool {
        guard let amountStr = transferAmountString,
              let amount = Double(amountStr),
              let fromCard = selectedFromAccount,
              amount <= fromCard.amount else {
            let formattedBalance = selectedFromAccount?.formattedAmount ?? "0.00"
            onValidationError?("Balans kifayət deyil. Mövcud balans: \(formattedBalance)")
            return false
        }
        return true
    }
    
    func completeTransfer() {
        guard let amountStr = transferAmountString,
              let amount = Double(amountStr),
              let fromIndex = cards.firstIndex(where: { $0.cardNumber == selectedFromAccount?.cardNumber }),
              let toIndex = cards.firstIndex(where: { $0.cardNumber == selectedToAccount?.cardNumber }) else {
            return
        }
        
        if  cardManager.makeTransfer(
            amount: amount,
            fromCardIndex: fromIndex,
            toCardIndex: toIndex
        ) {
            
            navigation?.returnHome()
        }
        
    }
}
