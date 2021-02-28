//
//  SetGame.swift
//  SetGame
//
//  Created by Petar Stanev on 19.01.21.
//

import Foundation

class SetGame {
    
    /// Active cards
    private(set) var activeCards: [Card] = []
    /// Cards in the deck
    private(set) var deckCards: [Card] = []
    /// Selected cards on the board
    var selectedCards = 0
    /// Game score
    private(set) var gameScore = 0
    /// Indexes of selected cards
    var selectedCardsIndexes: [Int] {
        return activeCards.enumerated().filter({ $0.element.isSelected }).map({ $0.offset })
    }
    /// If there is a set of 3 cards
    private(set) var isSet = false
    
    /// Select or deselect a card on the board
    /// - Parameter index: Card position
    func selectCard(at index: Int) {
        var tempCard = activeCards[index]
        tempCard.isSelected = !tempCard.isSelected
        selectedCards += tempCard.isSelected ? 1 : -1
        gameScore += tempCard.isSelected ? 0 : -1
        activeCards[index] = tempCard
        isSet = false
        
        // Checks if there is a Set of cards
        if selectedCards == 3 {
            isSet = checkIfSet(with: selectedCardsIndexes)
            
            if isSet {
                let removeIndexes = selectedCardsIndexes.sorted(by: { $1 < $0 })
                for currentIndex in removeIndexes
                {
                    activeCards.remove(at: currentIndex)
                }
            } else {
                for selectedCardIndex in selectedCardsIndexes {
                    activeCards[selectedCardIndex].isSelected = false
                }
            }
            
            gameScore += isSet ? 3 : -5
        }
    }
    
    /// Check if there is a set of three cards
    /// - Parameter indexes: Array of selected cards
    /// - Returns: True or false
    private func checkIfSet(with indexes: [Int]) -> Bool {
        guard selectedCardsIndexes.count == 3 else { return false }
        
        let firstCard = activeCards[selectedCardsIndexes[0]]
        let secondCard = activeCards[selectedCardsIndexes[1]]
        let thirdCard = activeCards[selectedCardsIndexes[2]]
        
        let colorSet = Set(arrayLiteral: firstCard.color,secondCard.color,thirdCard.color)
        let shapeSet = Set(arrayLiteral: firstCard.shape,secondCard.shape,thirdCard.shape)
        let numberSet = Set(arrayLiteral: firstCard.number,secondCard.number,thirdCard.number)
        let shadeSet = Set(arrayLiteral: firstCard.shade,secondCard.shade,thirdCard.shade)
        
        return (colorSet.count == 1 || colorSet.count == 3) &&
               (shapeSet.count == 1 || shapeSet.count == 3) &&
               (numberSet.count == 1 || numberSet.count == 3) &&
               (shadeSet.count == 1 || shadeSet.count == 3)
    }
    
    /// Add 3 more cards to the board
    func dealThree() {
        guard activeCards.count <= 21 && deckCards.count >= 3 else { return }
        
        for _ in 0 ..< 3 {
            activeCards.append(deckCards.remove(at: 0))
        }
    }
    /// Initial creation of all 81 cards in shuffled order and sets first 12 active cards on the board
    private func generateCards() {
        for color in Card.Color.allCases {
            for shape in Card.Shape.allCases {
                for number in Card.Number.allCases {
                    for shade in Card.Shade.allCases {
                        let card = Card(color: color,shape: shape,number: number,shade: shade)
                        deckCards.append(card)
                    }
                }
            }
        }
        
        deckCards.shuffle()
        
        for _ in 0 ..< 12 {
            activeCards.append(deckCards.remove(at: 0))
        }
    }
    
    init() {
        generateCards()
    }
}

