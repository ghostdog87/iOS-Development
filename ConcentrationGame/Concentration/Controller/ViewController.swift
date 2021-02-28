//
//  ViewController.swift
//  Concentration
//
//  Created by Petar Stanev on 14.01.21.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    private lazy var gameTheme = chooseGameTheme()
    private lazy var emojiChoices = chooseEmojiTheme()
    private var emoji: [Int: String] = [:]
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private weak var gameScoreLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func didTapNewGame() {
        gameTheme = chooseGameTheme()
        setGameTheme()
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        updateViewFromModel()
        emojiChoices = chooseEmojiTheme()
    }
    @IBAction private func touchCard(_ sender: UIButton) {
        guard let cardNumber = cardButtons.firstIndex(of: sender) else { return }
        
        game.chooseCard(at: cardNumber)
        updateViewFromModel()
    }
    
    override func viewDidLoad() {
        setGameTheme()
    }
    
    private func updateViewFromModel() {
        flipCountLabel.text = "Flips: \(game.flipCount)"
        gameScoreLabel.text = "Score: \(game.gameScore)"
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            let buttonTitle = card.isFacedUp ? emoji(for: card) : ""
            let buttonBackgroundColor = card.isFacedUp ? gameTheme["cardBackColor"] : card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : gameTheme["cardColor"]
            
            button.setTitle(buttonTitle, for: UIControl.State.normal)
            button.backgroundColor = buttonBackgroundColor
        }
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        
        return emoji[card.identifier] ?? "?"
    }
    
    private func chooseEmojiTheme() -> [String] {
        var emojiThemes: [String:[String]] = [:]
        
        emojiThemes["animals"] = ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐻‍❄️","🐨"]
        emojiThemes["fruits"] = ["🍏","🍎","🍐","🍊","🍋","🍌","🍉","🍇","🍓","🫐"]
        emojiThemes["balls"] = ["⚽️","🏀","🏈","⚾️","🥎","🎾","🏐","🏉","🥏","🎱"]
        emojiThemes["vehicles"] = ["🚗","🚕","🚙","🚌","🚎","🏎","🚓","🚑","🚒","🚐"]
        emojiThemes["items"] = ["🔫","💣","🧨","🪓","🔪","🗡","⚔️","🛡","🚬","⚰️"]
        emojiThemes["flags"] = ["🇦🇽","🇦🇱","🇩🇿","🇦🇸","🇦🇩","🇦🇴","🇦🇮","🇦🇶","🇦🇬","🇦🇷"]
                
        let themes = Array(emojiThemes.keys)
        let randomIndex = Int(arc4random_uniform(UInt32(themes.count)))
        let randomTheme = themes[randomIndex]
           
        return emojiThemes[randomTheme] ?? ["?"]
    }
    
    private func chooseGameTheme() -> [String : UIColor] {
        var gameThemes: [String:[String : UIColor]] = [:]
        
        gameThemes["halloween"] = ["backgroundColor": #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),"cardColor": #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1),"cardBackColor": #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        gameThemes["winter"] = ["backgroundColor": #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1),"cardColor": #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),"cardBackColor": #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)]
        gameThemes["contruction"] = ["backgroundColor": #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),"cardColor": #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),"cardBackColor": #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)]
                
        let AllThemesKeys = Array(gameThemes.keys)
        let randomIndex = Int(arc4random_uniform(UInt32(AllThemesKeys.count)))
        let randomTheme = gameThemes[AllThemesKeys[randomIndex]]
        
        return randomTheme ?? gameThemes["halloween"]!
    }
    
    private func setGameTheme() {
        view.backgroundColor = gameTheme["backgroundColor"]
        for index in cardButtons.indices {
            cardButtons[index].backgroundColor = gameTheme["cardColor"]
        }
    }
}

