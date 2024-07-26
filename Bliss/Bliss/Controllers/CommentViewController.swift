//
//  CommentViewController.swift
//  Bliss
//
//  Created by Admin on 7/20/24.
//

///
import UIKit

///A protocol to notify when a comment is added.
protocol CommentDelegate {
    func commentAdded(comment: FeedComment, tag: Int)
}

///This file defines the CommentViewController class, which manages the interface for displaying and adding comments on a feed item in the Bliss application.
///This class manages the interface for viewing and adding comments on a feed item.
class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Properties
    ///tableView: Displays the list of comments.
    @IBOutlet weak var tableView: UITableView!
    ///commentTf: Text field for entering new comments.
    @IBOutlet weak var commentTf: UITextField!
    ///noCommentsYetLbl: Label displayed when there are no comments.
    @IBOutlet weak var noCommentsYetLbl: UILabel!
    
    ///didAddCommentClick: Indicates if the add comment button was clicked.
    var didAddCommentClick: Bool?
    ///item: The feed item for which comments are being managed.
    var item: Feed?
    ///delegate: Delegate to notify when a comment is added.
    var delegate: CommentDelegate?
    ///tag: Identifier to associate the comment with a specific feed item.
    var tag: Int?
    ///isKeyboardShown: Tracks if the keyboard is shown.
    var isKeyboardShown = false
    
    
    // MARK: - Lifecycle Methods
    ///Called after the controller's view is loaded into memory. Sets up notifications for keyboard events and initializes the UI.
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupUI()
    }
    
    //MARK: - Setup Methods
    ///Sets up the UI components and their properties. Checks if the add comment button was clicked and displays the appropriate UI elements.
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: CommentItemTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CommentItemTableViewCell.identifier)
        
        if (didAddCommentClick == true) {
            commentTf.becomeFirstResponder()
        }
        
        if (item?.comments == nil || item?.comments?.isEmpty == true) {
            noCommentsYetLbl.isHidden = false
        }
        else {
            noCommentsYetLbl.isHidden = true
        }
        self.tableView.reloadData()
    }

    //MARK: - Keyboard Methods
    ///Adjusts the view when the keyboard is shown.
    @objc func keyboardWillShown(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if (isKeyboardShown == false ){
                isKeyboardShown = true
                self.view.frame.origin.y -= keyboardSize.height
            }
           
        }
    }

    ///Adjusts the view when the keyboard is hidden.
    @objc func keyboardWillBeHide(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if isKeyboardShown == true {
                isKeyboardShown = false
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    //MARK: - Action Methods
    ///Called when the send button is clicked. Adds the new comment to the feed item and notifies the delegate.
    @IBAction func onSendButtonClick(_ sender: Any) {
        if (commentTf.text?.trimmingCharacters(in: .whitespaces).isEmpty == false) {
            let feedComment = FeedComment(id: 1, comment: commentTf.text?.trimmingCharacters(in: .whitespaces), user: BaseData.getInstance().getCurrentUser())
            
            if item?.comments == nil {
                item?.comments = [feedComment]
            }
            else {
                item?.comments?.append(feedComment)
            }
            
            self.commentTf.text = ""
            noCommentsYetLbl.isHidden = true
            self.tableView.reloadData()
            self.delegate?.commentAdded(comment: feedComment, tag: tag!)
        }
    }
    
    //MARK: - UITableViewDataSource Methods
    
    ///Returns the number of rows in the table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item?.comments?.count ?? 0
    }
    
    ///Configures and returns the cell for the specified row in the table view.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentItemTableViewCell.identifier, for: indexPath) as! CommentItemTableViewCell
        cell.item = item?.comments![indexPath.row]
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
}

//MARK: - CommentItemDelegate Methods
extension CommentViewController: CommentItemDelegate {
    func onUserProfileClick(user: User) {
        ///Called when the user profile is clicked. Shows the user's profile.
        TinderViewController.show(self, user: user)
    }
}

//MARK: - Extension
extension CommentViewController {
    ///Creates and returns an instance of CommentViewController from the storyboard.
    static func create() -> CommentViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        
        return controller
    }
    
    ///Shows the CommentViewController as a popover with the specified parameters.
    static func show(_ viewController: UIViewController, didAddCommentClick: Bool?, item: Feed?, delegate: CommentDelegate, tag: Int) {
        let controller = CommentViewController.create()
        controller.didAddCommentClick = didAddCommentClick
        controller.item = item
        controller.delegate = delegate
        controller.tag = tag
        controller.modalPresentationStyle = .popover
        viewController.present(controller, animated: true, completion: nil)
    }
    
}
