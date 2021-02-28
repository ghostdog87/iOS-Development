//
//  Card.swift
//  SetGame
//
//  Created by Petar Stanev on 19.01.21.
//

import Foundation
import UIKit

struct Card {
    
    /// Card color (red, blue or green)
    var color: Color
    /// Card shape (triangle, circle or square)
    var shape: Shape
    /// Number of shapes on the card (1, 2 or 3)
    var number: Number
    /// Shade of card (striped, filled or outlined)
    var shade: Shade
    /// If card is selected
    var isSelected = false
    
    enum Color: CaseIterable {
        case Red
        case Blue
        case Green
    }
    
    enum Shape : String, CaseIterable {
        case Triangle = "▲"
        case Circle = "●"
        case Square = "■"
    }
    
    enum Number: Int, CaseIterable {
        case One = 1
        case Two = 2
        case Three = 3
    }
    
    enum Shade: CaseIterable {
        case Striped
        case Filled
        case Outlined
    }
}

extension Card.Color {
    func toUIColor() -> UIColor {
        switch self {
        case .Red:
            return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case .Green:
            return #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        case .Blue:
            return #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        }
    }
}

extension Card.Shade {
    func toFGColor() -> UIColor {
        switch self {
        case .Striped:
            return #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0.1499120447)
        case .Filled:
            return #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        case .Outlined:
            return #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
        }
    }
}
