//
//  ViewController.swift
//  SetGame
//
//  Created by Petar Stanev on 17.01.21.
//

import UIKit

class ViewController: UIViewController {
    
    lazy private var game = SetGame()
    
    @IBOutlet private weak var gameScoreLabel: UILabel!
    @IBOutlet private weak var setLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func didTapCard(_ sender: UIButton) {
        guard let cardIndex = cardButtons.firstIndex(of: sender), cardIndex < game.activeCards.count else { return }
        
        setLabel.text = ""
        game.selectCard(at: cardIndex)
        
        if game.selectedCards == 3 {
            clearBorder(at: Array(0 ..< cardButtons.count))
            game.selectedCards = 0
            setLabel.text = game.isSet ? "This was a Set! Hurray!" : "This was not a Set! Sorry :("
            
            if game.isSet {
                drawCards()
                removeInactiveCards()
            }
        } else {
            toggleBorder(at: cardIndex)
        }
        
        gameScoreLabel.text = "Score: \(game.gameScore)"
    }
    
    @IBAction private func didTapThreeMoreCards() {
        guard game.activeCards.count <= 21 && game.deckCards.count >= 3 else { return }
        game.dealThree()
        drawCards()
    }
    
    @IBAction private func didTapNewGame() {
        game = SetGame()
        drawCards()
        removeInactiveCards()
        let cardsIndexes = Array(0 ..< cardButtons.count)
        clearBorder(at: cardsIndexes)
        setLabel.text = ""
        gameScoreLabel.text = "Score: \(game.gameScore)"
    }
    
    /// Toggle card border
    /// - Parameter index: At selected position
    private func toggleBorder(at index: Int) {
        guard index < game.activeCards.count else { return }
        
        let card = game.activeCards[index]
        let borderWidth: CGFloat = card.isSelected ? 7.0 : 0.0
        let borderColor = card.isSelected ? UIColor.orange.cgColor : UIColor.white.cgColor
        let cornerRadius: CGFloat = card.isSelected ? 8.0 : 0.0
        
        drawBorder(of: cardButtons[index], withColor: borderColor, withWidth: borderWidth, withRadius: cornerRadius)
    }
    
    /// Remove card border
    /// - Parameter indexes: At listed positions
    private func clearBorder(at indexes: [Int]) {
        for index in indexes {
            drawBorder(of: cardButtons[index], withColor: UIColor.white.cgColor, withWidth: 0.0, withRadius: 0.0)
        }
    }
    
    /// Draw card border
    /// - Parameters:
    ///   - button: Selected card
    ///   - color: Border color
    ///   - width: Border width
    ///   - radius: Border radius
    private func drawBorder(of button: UIButton,withColor color: CGColor,withWidth width: CGFloat,withRadius radius: CGFloat) {
        button.layer.borderWidth = width
        button.layer.borderColor = color
        button.layer.cornerRadius = radius
    }
    
    /// Draw all active cards
    private func drawCards() {
        for (index, card) in game.activeCards.enumerated() {
            let strokeColor = card.color
            let foregroundColor = card.shade
            
            var attributes: [NSAttributedString.Key: Any] = [
                .strokeColor: strokeColor.toUIColor(),
                .strokeWidth: foregroundColor == Card.Shade.Outlined ? 10.0 : -10.0,
                .font: UIFont.systemFont(ofSize: 25)
            ]
            
            if foregroundColor != Card.Shade.Outlined {
                attributes[.foregroundColor] = foregroundColor.toFGColor()
            }
            
            let cardShape = card.shape.rawValue
            let cardShapeCount = card.number.rawValue
            let cardFigure = String(repeating: cardShape, count: cardShapeCount)
            let attributedString = NSAttributedString(string: cardFigure, attributes: attributes)
            
            cardButtons[index].setAttributedTitle(attributedString, for: .normal)
        } 
    }
    
    /// Remove inactive cards from board
    private func removeInactiveCards() {
        guard game.activeCards.count < 24 else { return }
        
        for index in game.activeCards.count ..< cardButtons.count {
            cardButtons[index].setAttributedTitle(nil, for: .normal)
        }
    }
    
    /// Load game
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawCards()
        setLabel.text = ""
    }
}
