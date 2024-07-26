//
//  ChatMainViewController.swift
//  Bliss
//
//  Created by Admin on 7/22/24.
//

import UIKit

///This file defines the ChatMainViewController class, which manages the chat interface for messaging between users. It handles displaying chat content and navigating back to previous screens.
///This class manages the main chat view, displaying chat messages and user information.
class ChatMainViewController: UIViewController {

    //MARK: - Properties
    
    ///contentView: A container view where the chat view controller will be added.
    @IBOutlet weak var contentView: UIView!
    ///nameLbl: A label displaying the name of the chat recipient.
    @IBOutlet weak var nameLbl: UILabel!
    ///profileImageView: An image view displaying the profile picture of the chat recipient.
    @IBOutlet weak var profileImageView: UIImageView!
    
    ///message: The message object associated with the chat.
    var message : Message?
    ///chatView: The chat view controller instance managing the chat content.
    var chatView:ChatViewController? = ChatViewController()
    ///user: The user object representing the chat recipient if creating a new message.
    var user: User?
    ///createNew: A boolean indicating if the chat is for a new message or not.
    var createNew = false
    
    //MARK: - Lifecycle Methods
    
    ///Called after the view has been loaded into memory. Sets up the profile image and name label based on the message or user data.
    override func viewDidLoad() {
        super.viewDidLoad()

        if let users = message?.recipients {
            if users.count > 0 {
                profileImageView.image = UIImage(named: users[0].profilePicture!)
                nameLbl.text = users[0].getFullname()
            }
        }
        else if user != nil {
            profileImageView.image = UIImage(named: (user?.profilePicture!)!)
            nameLbl.text = user?.getFullname()
        }
        
    }
    
    ///Called after the view has been added to the view hierarchy. Configures the chatView with the current message and adds it to the view controller hierarchy.
    override func viewDidAppear(_ animated: Bool) {
        chatView?.message = self.message
        chatView?.parentVC = self
        addViewController(chatView!)
        
        
    }
    
    //MARK: - Methods
    
    ///Adds the given view controller to the contentView with an animation. Sets up the view controller’s view and adds it to the view hierarchy.
    func addViewController(_ viewController: UIViewController!)  {
        
        let dst = viewController
        
        dst?.view.transform = CGAffineTransform(translationX: contentView.frame.size.width, y: 0)
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: UIView.AnimationOptions(),
                       animations: {
            dst?.view.transform = CGAffineTransform(translationX: 0, y: 0)
        },
                       completion: { finished in
        }
        )
        
        addChild(viewController!)
        viewController!.view.frame = contentView.bounds
        contentView.addSubview(viewController!.view)
        viewController?.didMove(toParent: self)
    }
    
    ///Removes the current chatView from the view hierarchy and cleans up the reference.
    func removeController() {
        chatView?.willMove(toParent: nil)
        chatView?.view.removeFromSuperview()
        chatView?.removeFromParent()
        chatView = nil
    }
    
    @IBAction func onBackClick(_ sender: Any) {
        if (createNew) {
            self.dismiss(animated: true)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

//MARK: - Extensions


extension ChatMainViewController {
    ///Creates and returns an instance of ChatMainViewController from the storyboard.
    static func create() -> ChatMainViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ChatMainViewController") as! ChatMainViewController
        
        return controller
    }
    
    ///Presents the ChatMainViewController on the navigation stack, displaying the chat for an existing message.
    static func show(_ viewController: UIViewController, item: Message?) {
        let controller = ChatMainViewController.create()
        controller.message = item
        viewController.navigationController?.pushViewController(controller, animated: true)
    }
    
    ///Presents the ChatMainViewController modally to create a new message with the specified user.
    static func showForNewMessage(_ viewController: UIViewController, item: User?) {
        let controller = ChatMainViewController.create()
        controller.user = item
        controller.createNew = true
        controller.modalPresentationStyle = .popover
        viewController.present(controller, animated: true, completion: nil)
    }
    
    ///Presents the ChatMainViewController on the navigation stack to create a new message from a match.
    static func showForNewMessageFromMatch(_ viewController: UIViewController, item: User?) {
        let controller = ChatMainViewController.create()
        controller.user = item
        viewController.navigationController?.pushViewController(controller, animated: true)
    }
}

