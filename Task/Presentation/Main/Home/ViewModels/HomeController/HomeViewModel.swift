//
//  HomeViewModel.swift
//  Task
//
//  Created by Sahib on 14.04.25.
//

import Foundation

final class HomeViewModel {
    enum ViewState {
        case success
        case error(String)
    }
    
    weak var navigation: HomeNavigation?
    var callBack : ((ViewState)-> Void)?
    private var cards : [CardModel ]  = []
    private var cardManager = CardManager.shared
    
    init(navigation: HomeNavigation){
        self.navigation = navigation
        cards = cardManager.cards
        configureObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(cardsDidUpdate),
            name: .cardsDidUpdate,
            object: nil
        )
    }
    
    @objc private func cardsDidUpdate() {
        cards = cardManager.cards
        callBack?(.success)
    }
    
    func showTransfer(){
        navigation?.showTransfer(cards:cards)
    }
    
    func getCardsCount() -> Int{
        return cards.count
    }
    
    func getCard (index: Int) -> CardModel {
        return cards[index]
    }
    
    func addRandomCard() {
        cardManager.addRandomCard()
    }
    
    func removeLastCard() -> Bool {
        cardManager.removeLastCard()
    }
}
