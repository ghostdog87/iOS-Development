//
//  Card.swift
//  Concentration
//
//  Created by Petar Stanev on 16.01.21.
//

import Foundation

struct Card {
    
    var isFacedUp = false
    var isMatched = false
    var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }    
}
