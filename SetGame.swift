//
//  SetGame.swift
//  SetGame
//
//  Created by Yorranshell Wattson on 10/15/18.
//  Copyright © 2018 Yorranshell Wattson. All rights reserved.
//

import Foundation
import UIKit

struct SetGame{
    private var deck = [Card]()
    private var discarded = [Card]()
//    var score: Int = 0  Tracked in ViewController instead for easier use
    private var tableCards = [Card]()
    private var matchedCards = [Card]()
    var chosenSet = [Card]()
    private var validSets = [[Card]]()
    
    private enum Colors : String{
        case red
        case green
        case purple
        
        static var allColors = [Colors.red, Colors.green, Colors.purple]
    }
    
    private enum Shapes : String{
        case oval = "⬤"
        case squiggle = "⌇"
        case diamond = "⬥"
        
        static var allShapes = [Shapes.oval, Shapes.squiggle, Shapes.diamond]
    }
    
    private enum Shadings : String{
        case empty
        case filled
        case striped
        
        static var allShading = [Shadings.empty, Shadings.filled, Shadings.striped]
    }
    
    private enum Counts : Int{
        case one = 1
        case two = 2
        case three = 3
        
        static var allCounts = [Counts.one, Counts.two, Counts.three]
    }
    
    mutating func setValidTableSets(Sets: [[Card]]){
        validSets = Sets
    }
    
    mutating func addValidSet(Set: [Card]){
        validSets.append(Set)
    }
    
   func getValidSets() -> [[Card]]{
            return validSets
    }
    
    func getTableCards() -> [Card] {
        return tableCards
    }
    
    func getChosenSet() -> [Card] {
        return chosenSet
    }
    
    mutating func setIsFaceUp(index: Int, isFaceUp: Bool){
        tableCards[index].isFaceUp = isFaceUp
    }
    
    //Find Solution Sets for cards
    func checkValidity(chosenSet: [Card]) -> Bool{
        let color = chosenSet[0].color
        let shape = chosenSet[0].shape 
        let shading = chosenSet[0].shading
        let count = chosenSet[0].count
        
        //same color - diff everything else
        if color == chosenSet[1].color && color == chosenSet[2].color && chosenSet[1].color == chosenSet[2].color{
            //print("Same color...")
            if (shape != chosenSet[1].shape)  && (shape != chosenSet[2].shape) && (chosenSet[1].shape != chosenSet[2].shape){
                if (shading != chosenSet[1].shading)  && (shading != chosenSet[2].shading) && (chosenSet[1].shading != chosenSet[2].shading){
                    if (count != chosenSet[1].count) && (count != chosenSet[2].count) && (chosenSet[1].count != chosenSet[2].count){
                       //print("Its a set!")
                        return true
                    }
                }
            }
        //print("Sorry")
        return false
        }
        
        //same shape - diff everything else
        if shape == chosenSet[1].shape && shape == chosenSet[2].shape && chosenSet[1].shape == chosenSet[2].shape{
            //print("Same shape...")
            if color != chosenSet[1].color  && color != chosenSet[2].color && chosenSet[1].color != chosenSet[2].color{
                if shading != chosenSet[1].shading  && shading != chosenSet[2].shading && chosenSet[1].shading != chosenSet[2].shading{
                    if count != chosenSet[1].count && count != chosenSet[2].count && chosenSet[1].count != chosenSet[2].count{
                        //print("Its a set!")
                        return true
                    }
                }
            }
        //print("Sorry")
        return false
        }
        
        //same shading - diff everything else
        if shading == chosenSet[1].shading && shading == chosenSet[2].shading && chosenSet[1].shading == chosenSet[2].shading{
            //print("Same shading...")
            if color != chosenSet[1].color  && color != chosenSet[2].color && chosenSet[1].color != chosenSet[2].color{
                if shape != chosenSet[1].shape  && shape != chosenSet[2].shape && chosenSet[1].shape != chosenSet[2].shape{
                    if count != chosenSet[1].count && count != chosenSet[2].count && chosenSet[1].count != chosenSet[2].count{
                        //print("It's a set!")
                        return true
                    }
                }
            }
            //print("Sorry")
           return false
        }
        
        //same count - diff everything else
        if count == chosenSet[1].count && count == chosenSet[2].count && chosenSet[1].count == chosenSet[2].count{
            //print("Same count...")
            if color != chosenSet[1].color  && color != chosenSet[2].color && chosenSet[1].color != chosenSet[2].color{
                if shape != chosenSet[1].shape  && shape != chosenSet[2].shape && chosenSet[1].shape != chosenSet[2].shape{
                    if shading != chosenSet[1].shading && shading != chosenSet[2].shading && chosenSet[1].shading != chosenSet[2].shading{
                        //print("It's a set!")
                        return true
                    }
                }
            }
            //print("Sorry")
            return false
        }
        
        //Dif everything
       if color != chosenSet[1].color && color != chosenSet[2].color && chosenSet[1].color != chosenSet[2].color{
            //print("Diff everything...")
            if shape != chosenSet[1].shape && shape != chosenSet[2].shape && chosenSet[1].shape != chosenSet[2].shape{
                if shading != chosenSet[1].shading && shading != chosenSet[2].shading && chosenSet[1].shading != chosenSet[2].shading{
                    if count != chosenSet[1].count && count != chosenSet[2].count && chosenSet[1].count != chosenSet[2].count{
                        //print("It's a set")
                        return true
                    }
                }
            }
        //print("Sorry")
        return false
        }
        //print("Not even close to a valid set")
        return false
    }
    
    
    mutating func findTableSolutions(){
        //Find Table Card Solutions (aka TableCards.count Choose 3)
        //Method 2
        print("\n\nFinding Table Solutions...")
        setValidTableSets(Sets: [[Card]]() ) //reset for updated table
        let maxIndex = tableCards.count - 1
        //var tracker = 0
        for indexA in 0...maxIndex - 2{
            let card1 = tableCards[indexA]
            let minB = indexA+1
            for indexB in minB...maxIndex - 1{
                let card2 = tableCards[indexB]
                let minC  = indexB+1
                for indexC in minC...maxIndex{
                    let card3 = tableCards[indexC]
                    let chosenSet = [card1, card2, card3]
                    let isValid = checkValidity(chosenSet: chosenSet)
                    if isValid{
                        addValidSet(Set: chosenSet)
                    }
                    //tracker += 1
                    //print("\(tracker) : \(isValid)") //print statements come before tracker and boolean
                    //print("\(tracker) : \(chosenSet) --- \(isValid)")
                }
            }
        }
        print("Done finding table solutions!")
        print("There are currently \(validSets.count) valid sets on the table:")
        print(validSets)
    }
    
    mutating func addCards(){
        var moreCards = [Card]()
        if deck.count >= 3{
            for _ in 1...3 {
                let i = arc4random_uniform(UInt32(deck.count)) //Note conversion betwen UInt32 and Int
                moreCards.append(deck[Int(i)])
                tableCards.append(deck[Int(i)])
                deck.remove(at: Int(i))
            }
            print("Added 3 more cards to the table:\n\(moreCards)")
        }else{
            print("Not enough cards in deck to add 3 more cards to table.")
        }
    }
    
    
    mutating func shuffle(){
        var newTableCards = [Card]()
        for _ in 1...tableCards.count{
            let i = arc4random_uniform(UInt32(tableCards.count)) //Note conversion betwen UInt32 and Int
            let card = tableCards[Int(i)]
            newTableCards.append(card)
            tableCards.remove(at: Int(i))
        }
        tableCards = newTableCards
        print("shuffled the table cards")
    }
    
    mutating func addOneCard() -> Card? {
        var card: Card? = Card(color:"none", shape:"none", shading:"none", count: -1, inChosenSet: false, isFaceUp: false)
        if deck.count >= 1{
            let i = arc4random_uniform(UInt32(deck.count)) //Note conversion betwen UInt32 and Int
            card = deck[Int(i)]
            deck.remove(at: Int(i))
        }
        else{
            print("No more cards left.")
            card = nil
        }
        return card
    }
    
    mutating func removeCard(card: Card){
        matchedCards.append(card)
        var index = -1
        for i in tableCards.indices {
            if tableCards[i].equals(Card: card){
                print("tablecard:\(tableCards[i])\ncard:\(card)")
                index = i
            }
        }
        tableCards.remove(at: index)
        print("Removed matched card from table.\n Matched cards in total: \(matchedCards.count)")
    }
    
    mutating func removeCardFromChosenSet(card: Card){
        for index in chosenSet.indices{
            if chosenSet[index].equals(Card: card){
                chosenSet.remove(at: index)
                break
            }
        }
    }

    mutating func removeFromAvailableSets(chosenSet: [Card]){
        print("Removing found set..")
        let card1 = chosenSet[0]
        let card2 = chosenSet[1]
        let card3 = chosenSet[2]

        for index in validSets.indices {
            let availableSet = validSets[index]
            let cardA = availableSet[0]
            let cardB = availableSet[1]
            let cardC = availableSet[2]
        
        //If chosen cards are unique and they match an available set, remove the set from being available.
            if !card1.equals(Card: card2) && !card1.equals(Card: card3) && !card2.equals(Card: card3) {
                if card1.equals(Card:cardA) ||  card1.equals(Card:cardB) ||  card1.equals(Card:cardC){
                    if card2.equals(Card:cardA) ||  card2.equals(Card:cardB) ||  card2.equals(Card:cardC) {
                        if card3.equals(Card:cardA) ||  card3.equals(Card:cardB) ||  card3.equals(Card:cardC) {
                            validSets.remove(at: index)
                            break //exit the for-in-loop so dont run into array index problems after set removal
                        }
                    }
                }
            }
        }
    print("Found set removed from available sets.")
    }

//Intialize Game
    init(){
        //Create the deck
        for i in Colors.allColors{
            let color = i
            for i in Shapes.allShapes{
                let shape = i
                for i in Shadings.allShading{
                    let shading = i
                    for i in Counts.allCounts{
                        let count = i
                        let card = Card(color:color.rawValue,shape:shape.rawValue,shading:shading.rawValue,count:count.rawValue, inChosenSet: false, isFaceUp: false)
                        //color,shape,shading,count - ORDER MATTERS
                        deck.append(card)
                    }
                }
            }
        }
        
        //Use a random group of 12 cards to start the game.
        for _ in 1...12 {
            let i = arc4random_uniform(UInt32(deck.count)) //Note conversion betwen UInt32 and Int
            tableCards.append(deck[Int(i)])
            deck.remove(at: Int(i))
        }
        
        print("\nThere are \(tableCards.count) cards on the table.")
        //print(startingCards)
        print("There are \(deck.count) cards remaining in the deck.")
        //print(deck)
    }
}
