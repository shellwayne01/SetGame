//
//  SetCardView.swift
//  SetGame
//
//  Created by Yorranshell Wattson on 11/3/18.
//  Copyright © 2018 Yorranshell Wattson. All rights reserved.
//

import UIKit

class SetCardView: UIView {
    var card: Card = Card(color:"none", shape:"none", shading:"none", count:0, inChosenSet: false, isFaceUp: false)

    //Sets inChosenSet bool value
    func touchCardView(){
        card.inChosenSet = !card.inChosenSet
        print("\(card) isChosen: \(card.inChosenSet)")
    }
    
}
