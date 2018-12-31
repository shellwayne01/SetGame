//
//  Card.swift
//  SetGame
//
//  Created by Yorranshell Wattson on 10/15/18.
//  Copyright © 2018 Yorranshell Wattson. All rights reserved.
//

import Foundation

struct Card {
    var color: String
    var shape: String
    var shading: String
    var count: Int
    var inChosenSet: Bool
    var isFaceUp: Bool
    
    func getModifiedShape() -> String {
        var modifiedShape = shape //original shape without any count. This could also just go into the Card class
        for _ in 1..<count{
            modifiedShape += shape //Shape is modified here to prevent logic error in game algorithms
        }
        return modifiedShape;
    }
    
    //Note: Cards Don't need same boolean for inChosenSet to be equal
    func equals(Card: Card) -> Bool {
        let otherCard = Card
        if self.color == otherCard.color{
            if self.shape == otherCard.shape{
                if self.shading == otherCard.shading{
                    if self.count == otherCard.count{
                        return true;
                    }
                }
            }
        }
        return false
    }
}
