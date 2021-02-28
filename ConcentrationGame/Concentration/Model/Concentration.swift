//
//  Concentration.swift
//  Concentration
//
//  Created by Petar Stanev on 16.01.21.
//

import Foundation

class Concentration {
    
    var cards: [Card] = []
    var gameScore = 0
    var flipCount = 0
    private var indexOfOnlyFacedUpCard: Int?
    private var seenCardIdentifier: [Int] = []
    
    func chooseCard(at index: Int){
        if cards[index].isMatched { return }
        
        flipCount += 1
        
        guard let matchIndex = indexOfOnlyFacedUpCard, matchIndex != index else {
            // Zero or two cards are currently faced up. New card is about to face up.
            for flipDownIndex in cards.indices {
                cards[flipDownIndex].isFacedUp = false
            }
            
            cards[index].isFacedUp = true
            indexOfOnlyFacedUpCard = index
            return
        }
        
        // Check if cards match. Second card just faced up.
        if cards[index].identifier == cards[matchIndex].identifier {
            cards[index].isMatched = true
            cards[matchIndex].isMatched = true
            gameScore += 2
        } else {
            checkCardStatus(for: cards[index].identifier)
            checkCardStatus(for: cards[matchIndex].identifier)
        }
        
        cards[index].isFacedUp = true
        indexOfOnlyFacedUpCard = nil
    }
    
    func checkCardStatus(for currentCardIdentifier: Int?) {
        guard let identifier = currentCardIdentifier else { return }
        
        seenCardIdentifier.contains(identifier) ? gameScore -= 1 : seenCardIdentifier.append(identifier)
    }
     
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards.append(contentsOf: [card,card])
        }
        
        cards.shuffle()
    }
}
