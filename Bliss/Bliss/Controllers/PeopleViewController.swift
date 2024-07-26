//
//  PeopleViewController.swift
//  Bliss
//
//  Created by Admin on 7/22/24.
//



import UIKit
///Shuffle_iOS: Provides the card stack interface for swiping functionality.
import Shuffle_iOS

///This file defines the PeopleViewController class, which manages a Tinder-like card stack interface for viewing potential matches in the Bliss application. Users can swipe left or right to pass or like other users, undo the last swipe, shuffle the deck, and send messages.
///This class manages the display and interaction with a stack of user cards.
class PeopleViewController: UIViewController {
    
    //MARK: - Properties
    ///cardStack: The card stack view for displaying user cards.
    @IBOutlet weak var cardStack: SwipeCardStack!
    ///noResultLbl: A label indicating no more results when all cards are swiped.
    @IBOutlet weak var noResultLbl: UILabel!
    ///buttonsStackView: A stack view containing action buttons.
    @IBOutlet weak var buttonsStackView: UIStackView!
    ///profilePictureIv: An image view that displays the current user's profile picture.
    @IBOutlet weak var profilePictureIv: UIImageView!
    
    ///cardModels: An array of TinderCardModel objects representing potential matches.
    private var cardModels: [TinderCardModel] = []
    
    //MARK: - Lifecycle Methods
    ///Called after the controller's view is loaded into memory. Sets the user's profile picture, loads potential matches into cardModels, shuffles them, and sets up the card stack's delegate and data source.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noResultLbl.isHidden = true
        profilePictureIv.image = UIImage(named: BaseData.getInstance().currentUser.profilePicture!)!
        BaseData.getInstance().peoples.forEach { user in
            cardModels.append(TinderCardModel(name: user.getFullname() ?? " ",
                                              age: user.age ?? 0,
                                              occupation: user.occupation ?? " ",
                                              image: UIImage(named: user.profilePicture ?? ""), user: user))
        }
        cardModels.shuffle()
        cardStack.delegate = self
        cardStack.dataSource = self
    }
    
    //MARK: - Actions
    ///Called when the undo button is clicked. Undoes the last swipe action.
    @IBAction func undoBtnClick(_ sender: Any) {
        cardStack.undoLastSwipe(animated: true)
    }
    
    ///Called when the pass button is clicked. Swipes the top card to the left.
    @IBAction func passBtnClick(_ sender: Any) {
        cardStack.swipe(.left, animated: true)
    }
    
    ///Called when the like button is clicked. Swipes the top card to the right.
    @IBAction func likeBtnClick(_ sender: Any) {
        cardStack.swipe(.right, animated: true)
    }
    
    ///Called when the shuffle button is clicked. Shuffles the card models and reloads the card stack.
    @IBAction func shuffleBtnClick(_ sender: Any) {
        
        cardModels.shuffle()
        cardStack.reloadData()
    }
    
    ///Called when the message button is clicked. Navigates to the chat interface for the user on the top card.
    @IBAction func messageBtnClick(_ sender: Any) {
        
        ChatMainViewController.showForNewMessage(self, item: cardModels[self.cardStack.topCardIndex!].user)
    }
    
    ///Called when the profile picture is clicked. Navigates to the current user's profile using MyProfileViewController.
    @IBAction func onMyProfileClick(_ sender: Any) {
        MyProfileViewController.show(self, item: BaseData.getInstance().currentUser)
    }
    
}

//MARK: - Extensions

extension PeopleViewController: SwipeCardStackDataSource, SwipeCardStackDelegate {
    
    ///Configures and returns a swipe card for the specified index. Sets up the card's content and footer with the corresponding model's data.
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
    
    ///Called when all cards have been swiped. Displays the "no result" label and hides the buttons stack view.
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        print("Swiped all cards!")
        noResultLbl.isHidden = false
        buttonsStackView.isHidden = true
        
    }
    
    ///Called when a card swipe is undone. Hides the "no result" label and displays the buttons stack view if there are still cards left.
    func cardStack(_ cardStack: SwipeCardStack, didUndoCardAt index: Int, from direction: SwipeDirection) {
        print("Undo \(direction) swipe on \(cardModels[index].name)")
        if(!cardModels.isEmpty) {
            noResultLbl.isHidden = true
            buttonsStackView.isHidden = false
        }
    }
    
    ///Called when a card is swiped. Logs the swipe direction and the name of the swiped car
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        print("Swiped \(direction) on \(cardModels[index].name)")
        
    }
    
    ///Called when a card is tapped. Logs the card tap event.
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
        print("Card tapped")
    }
    
}
