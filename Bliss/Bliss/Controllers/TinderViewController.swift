//
//  TinderViewController.swift
//  Bliss
//
//  Created by Admin on 7/20/24.
//



import UIKit
///Shuffle_iOS: A library that provides the card stack interface for Tinder-like swiping functionality.
import Shuffle_iOS

///This file defines the TinderViewController class, which manages the Tinder-like card swiping interface in the Bliss application. The interface allows users to swipe left or right on cards representing other users.
///This class manages the Tinder-like card swiping interface.
class TinderViewController: UIViewController {
    
    //MARK: - Properties
    ///cardStack: The card stack interface that displays the swipeable cards.
    @IBOutlet weak var cardStack: SwipeCardStack!
    ///user: The user whose profile is being displayed in the cards.
    var user: User?
    ///cardModels: The models representing the data for the cards.
    private var cardModels: [TinderCardModel] = []
    
    //MARK: - Lifecycle Methods
    //Called after the controller's view is loaded into memory. Initializes the card models and sets up the card stack delegate and data source.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardModels =  [TinderCardModel(name: user?.getFullname() ?? " ",
                                       age: user?.age ?? 0,
                                       occupation: user?.occupation ?? " ",
                                       image: UIImage(named: user?.profilePicture ?? ""), user: user)]
        cardStack.delegate = self
        cardStack.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Actions
    ///Called when the pass button is clicked. Swipes the current card to the left.
    @IBAction func passBtnClick(_ sender: Any) {
        cardStack.swipe(.left, animated: true)
    }
    
    ///Called when the like button is clicked. Swipes the current card to the right.
    @IBAction func likeBtnClick(_ sender: Any) {
        cardStack.swipe(.right, animated: true)
    }
    
    ///Called when the message button is clicked. Opens the chat interface for sending a new message to the user on the current card.
    @IBAction func messageBtnClick(_ sender: Any) {
        ChatMainViewController.showForNewMessage(self, item: cardModels[self.cardStack.topCardIndex!].user)
    }
}

//MARK: - Extensions
extension TinderViewController: SwipeCardStackDataSource, SwipeCardStackDelegate {
    
    ///Configures and returns a card for the specified index in the card stack.
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        let card = SwipeCard()
        card.footerHeight = 80
        card.swipeDirections = [.left, .right]
        for direction in card.swipeDirections {
            card.setOverlay(TinderCardOverlay(direction: direction), forDirection: direction)
        }
        
        let model = cardModels[index]
        card.content = TinderCardContentView(withImage: model.image)
        card.footer = TinderCardFooterView(withTitle: "\(model.name), \(model.age)", subtitle: model.occupation)
        
        return card
    }
    
    ///Returns the number of cards in the card stack.
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return cardModels.count
    }
    
    ///Called when all cards have been swiped.
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        print("Swiped all cards!")
        
    }
    
    ///Called when a card swipe is undone.
    func cardStack(_ cardStack: SwipeCardStack, didUndoCardAt index: Int, from direction: SwipeDirection) {
        print("Undo \(direction) swipe on \(cardModels[index].name)")
    }
    
    ///Called when a card is swiped in a specified direction. Dismisses the view controller after a swipe.
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        print("Swiped \(direction) on \(cardModels[index].name)")
        self.dismiss(animated: true)
    }
    
    ///Called when a card is tapped.
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
        print("Card tapped")
    }
    
}


extension TinderViewController {
    ///Creates and returns an instance of TinderViewController from the storyboard.
    static func create() -> TinderViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TinderViewController") as! TinderViewController
        
        return controller
    }
    
    ///Shows the TinderViewController as a popover with the specified user.
    static func show(_ viewController: UIViewController, user: User?) {
        let controller = TinderViewController.create()
        controller.user = user
        controller.modalPresentationStyle = .popover
        viewController.present(controller, animated: true, completion: nil)
    }
    
}
