//
//  ViewController.swift
//  SetGame
//
//  Created by Yorranshell Wattson on 10/15/18.
//  Copyright © 2018 Yorranshell Wattson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var game = SetGame()
    
    lazy var tableCards: [Card] = game.getTableCards()
    
    private var tableCardSubViews: [SetCardView] = []
    
    @IBOutlet var newGameButton: UIButton!
    
    @IBOutlet var scoreLabel: UILabel!
    
    @IBOutlet var deck: UIImageView!
    
    @IBOutlet var discardPile: UIImageView!
    
    private var numCardsChosen = 0
    
    private(set) var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    @IBOutlet weak var setGameView: SetGameView!{
        didSet {
            let pinch = UIPinchGestureRecognizer(target: self,
                                                 action: #selector(shuffleSubViews(_:)))
            setGameView.addGestureRecognizer(pinch)


            let tap = UITapGestureRecognizer(target: self, action: #selector(chooseSubView(_:)))
            setGameView.addGestureRecognizer(tap)
        }
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        print("new view controller")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGameView.setCards = tableCards //Updates setCards in set game view upon 1st load
        let deckImg: UIImage = UIImage(named: "Deck.png")!
        let discardDeckImg: UIImage = UIImage(named: "DiscardDeck.jpg")!
        deck.image = deckImg
        discardPile.image = discardDeckImg
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(touchedDeck(_:)))
        deck.isUserInteractionEnabled = true
        deck.addGestureRecognizer(tap2)
        
        //No card views to work with since they haven't been added to the game view. Unless if I create placeholder views and animate those.
        print("-----------------------------------------------view loaded")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Perfect time to set starting positions for animations
        //Still no card views to work with since they haven't been added to the game view. Unless if I create placeholder views and animate those.
        print("-----------------------------------------------view will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Perfect time to animate upon initialization
//        UIView.animate(withDuration: 1.5) { //Closure - "self" is needed
//            self.deck.center.x += self.view.bounds.width * 0.1
//            self.discardPile.center.x -= self.view.bounds.width * 0.1
//        }
        
        //Card views are now available to animate but user has already seen them unless if we hide them, move them, and then animate them back to position.
        print(tableCards)
        game.findTableSolutions()
        print("-----------------------------------------------view did appear")
    }
    
    @objc func touchedDeck(_ recognizer: UITapGestureRecognizer){
        switch recognizer.state {
        case .ended: print("\n\n---Deck Tapped---")
                    if game.getValidSets().count > 0{
                        score -= 10 * game.getValidSets().count
                    }
                    if tableCards.count <= 79{
                        game.addCards()
                        tableCards = game.getTableCards() //updates current table cards
                        updateView()
                    }else {
                        print("\n\nNo more cards to deal!")
                    }
        default:
            break
        }
    }
    
    @objc func shuffleSubViews(_ recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            print("\n\n---Shuffled---")
            game.shuffle()
            setGameView.setCards = game.getTableCards() //shuffling changes indices so need this here before updating view
            updateView()
        default:
            break
        }
    }
    
    //Selects and De-selects card views
    @objc func chooseSubView(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            print("\n\n---Tapped---")
            //Determines if a card view was actually clicked and then places it in chosen views []
            setGameView.findCard(recognizer)
            let chosenViews = setGameView.getChosenCardView()
            
            //Checks chosen set
            if chosenViews.count == 3{
                var set: [Card] = []
                for view in chosenViews{
                    set.append(view.card)
                }
                let isValid = game.checkValidity(chosenSet: set)
                if isValid{
                    game.addValidSet(Set: set)
                    score += 20
                    print("You found a set 😄🙌🎉")
                    game.removeFromAvailableSets(chosenSet: set);
                    
                    var delay = 0.0
                    for view in chosenViews{
                        let randX = arc4random_uniform(UInt32(setGameView.bounds.maxX))
                        let randY = arc4random_uniform(UInt32(setGameView.bounds.maxY))
                        print("Random coordinates: (\(randX),\(randY))")
                        setGameView.bringSubview(toFront: view)
                        
                        //Animation 1 - Fly away.  Note: Card View is always going to be constrained to set game view bounds
                        UIView.transition(with: view, duration: 3.0, options: [],
                                          animations: {
                                            view.center.x = CGFloat( randX )
                                            view.center.y = CGFloat( randY )
                                        },
                                          completion: {finished in
                                        //Animation 2 - Funny animation then go to discard pile.
                                            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 2.0,delay: 0,
                                                                                           options: [],
                                                                                           animations: {
                                                view.transform = CGAffineTransform.identity.scaledBy(x: 2.0, y: 2.0)
                                                view.transform = CGAffineTransform(rotationAngle: 180 ) 
                                                view.transform = CGAffineTransform.identity.scaledBy(x: 0.25, y: 0.25)
                                                view.center.x = CGFloat( self.discardPile.center.x )
                                                view.center.y = CGFloat( self.discardPile.center.y )
                                            },
                                                                                           completion: {finished in
                                                                                            //Discard cards
                                                                                
                                                                                            self.game.removeCard(card: view.card)
                                                                                            
                                                                                            //Why is this line only removing last view?
//                                                                                            view.removeFromSuperview()
                                                                                
                                                                                            //Same issue
                                                                                            chosenViews.forEach({view in
                                                                                                 view.removeFromSuperview()
                                                                                            })
                                                                                            
                                
                                                                                            if chosenViews.index(of: view) == chosenViews.count - 1{ //if last index
                                                                                             self.updateView()
                                                                                            }
                                                                                            })
                        })
                        delay += 0.2 //dont add inside animations since this must occur immediately in the for loop
                    }
                    
                    game.addCards()
                    print("Should be:\n\(game.getTableCards().count)" )
                    print("Actually is:\n\(tableCards.count)")
                }else{
                    score -= 25
                    print("Not a set")
                }
            }
            setGameView.resetChosenSet() //clears chosen set when appropriate - Does it reset after a match is found?
        default:
            break
        }
    }
    
    func updateView(){
        //Updates after adding cards or shuffling
        //Updates table cards in controller and view
        //Track which cards are faceUp
        for index in setGameView.setCards.indices{
            game.setIsFaceUp(index: index, isFaceUp: setGameView.setCards[index].isFaceUp)
        }
        tableCards = game.getTableCards()
        setGameView.setCards = tableCards
        tableCardSubViews = setGameView.tableCardViews//prob not always uptodate. Optional
        
        setGameView.setNeedsDisplay()
        setGameView.setNeedsLayout()
        game.findTableSolutions()
    }
}
