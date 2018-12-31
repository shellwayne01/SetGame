//
//  SetGameView.swift
//  SetGame
//
//  Created by Yorranshell Wattson on 10/29/18.
//  Copyright © 2018 Yorranshell Wattson. All rights reserved.
//

import UIKit

class SetGameView: UIView {
    lazy var setCards: [Card] = [] //gets cards from controller after each load
    private var cardHeight: CGFloat = 0.0
    private var cardWidth: CGFloat = 0.0
    private var latestX: CGFloat = 0.0
    private var latestY: CGFloat = 0.0
    
    var tableCardViews: [SetCardView] = [] //a set of card views --> Might have to fill with empty cards upon layout to allow Grid use
    var chosenCardViews: [SetCardView] = []
    
    private let color1: UIColor = #colorLiteral(red: 0.7961697589, green: 0.7802893631, blue: 0.9189800127, alpha: 1)
    private let color2: UIColor = #colorLiteral(red: 0.9882352941, green: 0.9490196078, blue: 1, alpha: 1)
    private var counter: Int = 0
    private var cornerRadius: CGFloat {
        return CGFloat(cardHeight * 0.25)
    }
    
    //Creates and draws card views inside of the SetGameView rect
    override func draw(_ rect: CGRect) {
        print("Dimensions for set game view's drawing rect: \(rect)")
        createBlankCardViews()//create and animate placeholder card views. Note: The following card drawings technically happen almost simultaneously as the creation of black cards due to the nature of swift.
        var index = 0
        
        //Create real cards views to replace placeholders
        for card in setCards {
            let cardView = tableCardViews[index] //for now
            cardWidth = cardView.frame.width
            cardHeight = cardView.frame.height
            cardView.card = card
            cardView.backgroundColor = color1 //avoid using same color as stripes
            cardView.clipsToBounds = true
//            print("\n\n\nCard Number: \(counter)\nSub view frame: \(cardView.frame)\nCard: \(card)")

            //Add drawings with appropriate properties to card views
            let shapeLayer = CAShapeLayer()
            shapeLayer.lineWidth = 1.0
            shapeLayer.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor;
            shapeLayer.fillColor = UIColor.white.cgColor

            var withStripes: Bool = false
            switch card.color{
                case "red": shapeLayer.strokeColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).cgColor;
                case "green": shapeLayer.strokeColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1).cgColor;
                case "purple": shapeLayer.strokeColor = #colorLiteral(red: 0.7751092091, green: 0.2673456491, blue: 0.9686274529, alpha: 1).cgColor;
                default: print("Not a valid card color.")
            }
            switch card.shading{
                case "empty": shapeLayer.fillColor = color2.cgColor
                                shapeLayer.lineWidth = 2.0
                case "filled":  shapeLayer.fillColor = shapeLayer.strokeColor
                                shapeLayer.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
                case "striped": withStripes = true
                default: print("Not a valid shade.")
            }
            switch card.shape{
                case "⬤": shapeLayer.path = drawOval(count: card.count, withStripes: withStripes).cgPath
                case "⌇": shapeLayer.path = drawSquiggle(count: card.count, withStripes: withStripes).cgPath
                case "⬥": shapeLayer.path = drawDiamond(count: card.count, withStripes: withStripes).cgPath
                default:
                        print("Invalid shape used. Try again")
                        shapeLayer.fillColor = UIColor.black.cgColor
                        shapeLayer.path = drawOval(count: card.count, withStripes: withStripes).cgPath;
            }
            
            if withStripes{
                let context = UIGraphicsGetCurrentContext()
                context!.saveGState()
                shapeLayer.fillColor = shapeLayer.strokeColor //stroke and fill are background color here of stripes  outside the bezier
                shapeLayer.lineWidth = 2.0
                context!.addPath(shapeLayer.path!)
                context!.addRect(cardView.frame) //cardView.bounds will serve as rect
                context!.clip()
                cardView.backgroundColor = UIColor.white //background color inside bezier path
                context!.restoreGState()
            }
            
            //Display and track card view
            cardView.layer.addSublayer(shapeLayer)
            index += 1
        }
        print("\n\nCard Views created and stored for \(tableCardViews.count) table cards.")
        print("Set cards: \(setCards.count).")
    }
    
    private func drawOval(count:Int, withStripes: Bool ) -> UIBezierPath{
        let ovalPath = UIBezierPath()
        let cardW = cardWidth/CGFloat(count)
        var space: CGFloat = 0
        //change ovals to nicer one if theres time
        for _ in 1...count{
            ovalPath.move(to: CGPoint(x:0 + space , y:cardHeight * 0.2 ))
            ovalPath.addQuadCurve(to: CGPoint(x:cardW  + space, y:cardHeight * 0.2), controlPoint: CGPoint(x:cardW/2  + space, y:0))
            ovalPath.addLine(to: CGPoint(x:cardW + space, y: cardHeight * 0.8))
            ovalPath.addQuadCurve(to: CGPoint(x:0 + space , y:cardHeight * 0.8), controlPoint: CGPoint(x:cardW/2 + space, y: cardHeight))
            ovalPath.addLine(to: CGPoint(x:0 + space , y: cardHeight * 0.3 ))
            ovalPath.close()
            space += cardW
        }
        
        if withStripes {
            let shapePath = drawStripes()
//            ovalPath.addClip()
            ovalPath.append(shapePath)
        }
    return ovalPath
    }
    
    private func drawSquiggle(count:Int, withStripes: Bool) -> UIBezierPath{
        let squigglePath = UIBezierPath()
        
        if withStripes {
            let shapePath = drawStripes()
//            squigglePath.addClip()
            squigglePath.append(shapePath)
        }
        
        //Method 2: Transform
        let cardW = cardWidth/CGFloat(count)
        var space: CGFloat = 0
        
        for _ in 1...count{
            squigglePath.move(to: CGPoint(x:cardW/3 + space , y:cardHeight/2))
            squigglePath.addLine(to: CGPoint(x: cardW/3  + space, y: cardHeight/4))
            squigglePath.addCurve(to:CGPoint(x: cardW/8  + space, y:cardHeight/8), controlPoint1: CGPoint(x:cardW/6  + space, y: cardHeight/7), controlPoint2: CGPoint(x: 0  + space , y: cardHeight/8))
            squigglePath.addCurve(to:CGPoint(x: cardW * 2/3 + space , y:cardHeight/4), controlPoint1: CGPoint(x:cardW/3  + space, y: 0), controlPoint2: CGPoint(x: cardW/2  + space , y: 0))
            
            squigglePath.addLine(to: CGPoint(x: cardW * 2/3  + space , y: cardHeight * 0.6))
            squigglePath.addCurve(to: CGPoint(x: cardW * 7/8  + space, y:cardHeight * 7/8), controlPoint1: CGPoint(x:cardW * 3/4  + space, y: cardHeight * 3/4), controlPoint2: CGPoint(x: cardW * 0.9  + space , y: cardHeight * 0.6))
            squigglePath.addCurve(to:CGPoint(x: cardW/3  + space , y:cardHeight * 3/4), controlPoint1: CGPoint(x:cardW * 0.7  + space, y: cardHeight), controlPoint2: CGPoint(x: cardW * 0.45  + space , y:cardHeight * 0.8))
            squigglePath.addLine(to: CGPoint(x:cardW/3 + space , y:cardHeight/2))
            squigglePath.close()
            space += cardW
        }
        return squigglePath
    }
    
    private func drawDiamond(count:Int, withStripes: Bool) -> UIBezierPath{
        let diamondPath = UIBezierPath()
    
        //Method 2: Transform
        let cardW = cardWidth/CGFloat(count)
        var space: CGFloat = 0
        
        for _ in 1...count{
            diamondPath.move(to: CGPoint(x: 0 + space, y: cardHeight/2 )) //start at the left-center
            diamondPath.addLine(to: CGPoint(x: cardW/2 + space, y: 0))
            diamondPath.addLine(to: CGPoint(x: cardW + space, y: cardHeight/2))
            diamondPath.addLine(to: CGPoint(x: cardW/2 + space , y: cardHeight))
            diamondPath.addLine(to: CGPoint(x: 0 + space , y: cardHeight/2))
            diamondPath.close()
            space += cardW
        }

        if withStripes {
            let shapePath = drawStripes()
//            diamondPath.addClip()
            diamondPath.append(shapePath)
        }
        
        return diamondPath
    }
    
    private func drawStripes() -> UIBezierPath{
        let percentage = [0.1,0.2,0.3,0.4,0.5, 0.6,0.7, 0.8,0.9, 1.0]
        let stripes = UIBezierPath()
        for perc in percentage {
            stripes.move(to: CGPoint(x:0, y: cardHeight * CGFloat(perc)))
            stripes.addLine(to: CGPoint(x: cardWidth, y: cardHeight * CGFloat(perc)))
        }
        stripes.move(to: CGPoint(x: 0, y:0 ))
        stripes.addLine(to: CGPoint(x: 0, y:cardHeight ))
        stripes.addLine(to: CGPoint(x: cardWidth, y:cardHeight ))
        stripes.addLine(to: CGPoint(x: cardWidth, y:0 ))
        stripes.addLine(to: CGPoint(x: 0, y:0 ))
        stripes.close()
        return stripes
    }
    
    //Creates card view placeholders with animations
    func createBlankCardViews(){
        self.subviews.forEach { //Reset subviews
            $0.removeFromSuperview()
            latestX = 0
            latestY = 0
        }
        counter = 0 //reset counter
        tableCardViews = [] //Reset card view tracker
        
        //Use Grid to calculate frames
        let setGrid = Grid(for: self.frame,
                           withNoOfFrames: self.setCards.count,
                           forIdeal: 2.0)
        var delay = 0.0
        
        //Note: for-loop continues before animation ends
        for i in setCards.indices {
            let cardView: SetCardView = SetCardView() //an empty card view
        
            if var frame = setGrid[i] { //--Using GRID to set dimensions for each card frame--
                frame.size.width -= 5
                frame.size.height -= 5
                cardView.frame = frame
            }
            self.addSubview(cardView) //adds actual subview
            tableCardViews.append(cardView) //adds view to an array of table card views
            
            //If card is face down(ex.NEWLY DEALT) hide it, move it, then show it moving into grid position via animation.
            if !setCards[i].isFaceUp{
                let cardBackView: UIView = UIView() //an empty card view
                cardBackView.backgroundColor = UIColor.red
                cardBackView.frame = cardView.frame
                self.addSubview(cardBackView)
            
                let originalX = cardView.center.x //get Grid coords
                let originalY = cardView.center.y
                    cardView.isHidden = true
                    cardView.center.x  = self.frame.minX
                    cardView.center.y  = self.frame.maxY
                
                    cardBackView.isHidden = true
                    cardBackView.center.x  = self.frame.minX
                    cardBackView.center.y  = self.frame.maxY
                    cardBackView.isHidden = false

                    //Animation 1 - move card to GRID position
                    UIView.animate(withDuration:3.0, delay: TimeInterval(delay), options:[],
                                   animations: {
                                    cardView.center.x = originalX //self already implied
                                    cardBackView.center.x = originalX
                                    cardView.center.y = originalY
                                    cardBackView.center.y = originalY},
                                   
                                   completion:{finished in
                                    //Animation 2: Flip Card
                                    UIView.transition(with: cardView,
                                                      duration: 0.3,
                                                      options: [.transitionFlipFromLeft],
                                                      animations: {
                                                        cardBackView.isHidden = true
                                                        cardView.isHidden = false
                                    })
                    })
                    //Increment delay in prep for next card view
                    setCards[i].isFaceUp = true
                    cardView.card.isFaceUp = true
                    delay += 0.2
            }
        }
    }
    
    private func getLatestX() -> CGFloat{
        return latestX
    }
    
    private func getLatestY() -> CGFloat{
        return latestY
    }
    
    func getCardViews()->[SetCardView]{ //all card views
        return tableCardViews
    }
    
    func getChosenCardView() -> [SetCardView]{
        return chosenCardViews
    }
    
    func resetChosenSet(){
        if chosenCardViews.count >= 3{
            for cardView in tableCardViews{
                cardView.card.inChosenSet = false
            }
            chosenCardViews = [] //reset
            print("Choose a new set")
        }
    }
    
    //Determines if user actually tapped a card view
    func findCard(_ recognizer: UITapGestureRecognizer){
        let touchLocation: CGPoint = recognizer.location(in: self)
        let viewAtLocation = hitTest(touchLocation, with:nil)
        if viewAtLocation is SetCardView{
            for cardView in tableCardViews{
                if viewAtLocation == cardView{
                    cardView.touchCardView()
                    //print(viewAtLocation as Any)
                }
            }
        }
        //Updates chosen card views []
        chosenCardViews = [] //reset 
        for cardView in tableCardViews{
            if cardView.card.inChosenSet{
                chosenCardViews.append(cardView)
                cardView.layer.borderColor = UIColor.green.cgColor
                cardView.layer.borderWidth = 2.0
            }else{
                cardView.layer.borderColor = nil
                cardView.layer.borderWidth = 0
            }
        }
        print ("\(chosenCardViews.count) cards in chosen set") 
    }
    
    override func layoutSubviews() {
        print("Laying out sub views.")
        super .layoutSubviews()
    }
    
    

}




