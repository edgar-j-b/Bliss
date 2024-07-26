//
//  FeedItemTableViewCell.swift
//  Bliss
//
//  Created by Admin on 7/20/24.
//

import UIKit

///A protocol defining delegate methods for handling interactions with the feed item.
protocol FeedItemDelegate {
    ///Notifies the delegate when the add comment button is clicked.
    func onAddCommentClick(item:Feed,view: FeedItemTableViewCell)
    ///Notifies the delegate when the view all comments button is clicked.
    func onShowCommentClick(item:Feed,view: FeedItemTableViewCell)
    ///Notifies the delegate when the like/dislike action occurs.
    func onLikeDislikeFeed(isLiked:Bool,view: FeedItemTableViewCell)
    ///Notifies the delegate when the view all likes button is clicked.
    func onViewLikesClick(item: Feed)
    /// Notifies the delegate when a user profile is clicked.
    func onUserProfileClick(user: User)
    ///Notifies the delegate when the share button is clicked.
    func onShareClick(item: Feed)
}

///FeedItemTableViewCell is a custom UITableViewCell used to display feed items in a table view. It includes user profile information, feed content (such as photos and text), and interactive elements like like, comment, and share buttons. The cell also manages user interactions through a delegate.
class FeedItemTableViewCell: UITableViewCell {
    
    ///A static identifier used for dequeuing instances of this cell in a table view. The default value is "FeedItemTableViewCell".
    static let identifier = "FeedItemTableViewCell"
    ///An IBOutlet connected to an UIImageView that displays the user's profile picture.
    @IBOutlet weak var profilePictureIv: UIImageView!
    ///An IBOutlet connected to a UILabel that displays the user's full name.
    @IBOutlet weak var nameLbl: UILabel!
    ///An IBOutlet connected to a UILabel that displays the activity associated with the feed item (e.g., "posted a photo").
    @IBOutlet weak var actionLbl: UILabel!
    ///An IBOutlet connected to a UIImageView that displays the feed photo.
    @IBOutlet weak var photoIv: UIImageView!
    ///An IBOutlet connected to a UILabel that displays the creation date of the feed item.
    @IBOutlet weak var createdLbl: UILabel!
    ///An IBOutlet connected to a UIImageView that displays the like icon. It updates based on whether the feed item is liked or not.
    @IBOutlet weak var likeIv: UIImageView!
    ///An IBOutlet connected to a UILabel that displays the number of likes for the feed item.
    @IBOutlet weak var numberOfLikesLbl: UILabel!
    ///An IBOutlet connected to a UILabel that displays the number of comments for the feed item.
    @IBOutlet weak var numberOfCommentsLbl: UILabel!
    ///An IBOutlet connected to a UIView that contains the like-related UI elements. It is hidden if there are no likes.
    @IBOutlet weak var likesView: UIView!
    ///An IBOutlet connected to a UIView that contains the comment-related UI elements. It is hidden if there are no comments.
    @IBOutlet weak var commentsView: UIView!
    ///A delegate conforming to the FeedItemDelegate protocol. It is used to handle interactions with the feed item, such as liking, commenting, and sharing.
    var delegate: FeedItemDelegate?
    ///An optional integer representing the index of the feed item in the table view.
    var index: Int?
    
    /// A property representing the feed item to be displayed in the cell. When set, it updates the UI elements with the feed's data, including user profile picture, activity, photo, creation date, likes, comments, and like status.
    public var item: Feed! {
        didSet {
            if let user = item.user {
                profilePictureIv.image = UIImage(named: user.profilePicture!)
                nameLbl.text = user.getFullname()
            }
            actionLbl.text = item.activty
            photoIv.image = UIImage(named: item.photoUrl!)
            createdLbl.text = item.created
            
            if item.likes != nil && item.likes!.count > 0 {
                if item.likes?.count == 1 {
                    numberOfLikesLbl.text = "1 like"
                }
                else {
                    numberOfLikesLbl.text = String(item.likes!.count) + " likes"
                }
                likesView.isHidden = false
            }
            else {
                likesView.isHidden = true
            }
            
            if item.comments != nil && item.comments!.count > 0 {
                if item.comments?.count == 1 {
                    numberOfCommentsLbl.text = "View 1 comment"
                }
                else {
                    numberOfCommentsLbl.text = "View all " + String(item.comments!.count) + " comments"
                }
                commentsView.isHidden = false
            }
            else {
                commentsView.isHidden = true
            }
            
            if item.isLike == true {
                likeIv.image = UIImage(named: "ic_liked")
            }
            else {
                likeIv.image = UIImage(named: "ic_like")
            }
            
        }
    }
    
    ///Called after the view has been loaded from the nib file. This method is used to perform any additional setup after the cell has been loaded. The default implementation calls the superclass's awakeFromNib() method.
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    ///Called when the cell is selected or deselected. This method allows for additional configuration when the cell's selection state changes.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    ///Called when the like button is clicked. It toggles the like status of the feed item and updates the likeIv image accordingly. It then notifies the delegate about the like/dislike action.
    @IBAction func onLikeClick(_ sender: Any) {
        
        if item.isLike == true {
            likeIv.image = UIImage(named: "ic_like")
            item.isLike = false
            self.delegate?.onLikeDislikeFeed(isLiked: false, view: self)
            
        }
        else {
            likeIv.image = UIImage(named: "ic_liked")
            item.isLike = true
            self.delegate?.onLikeDislikeFeed(isLiked: true, view: self)
        }
        
    }
    
    ///Called when the comment button is clicked. It notifies the delegate to handle adding a comment to the feed item.
    @IBAction func onCommentClick(_ sender: Any) {
        self.delegate?.onAddCommentClick(item: item,view: self)
    }
    
    ///Called when the share button is clicked. It notifies the delegate to handle sharing the feed item.
    @IBAction func onShareClick(_ sender: Any) {
        self.delegate?.onShareClick(item: item)
    }
    
    ///Called when the view all likes button is clicked. It notifies the delegate to handle viewing all likes for the feed item.
    @IBAction func onViewAllLikesClick(_ sender: Any) {
        self.delegate?.onViewLikesClick(item: item)
    }
    
    ///Called when the view all comments button is clicked. It notifies the delegate to handle showing all comments for the feed item.
    @IBAction func onViewAllCommentsClick(_ sender: Any) {
        self.delegate?.onShowCommentClick(item: item,view: self)
    }
    
    ///Called when the user profile button is clicked. It checks if the user is not the current user (obtained from BaseData.getInstance().getCurrentUser()) and, if so, notifies the delegate about the user profile click event.
    @IBAction func onUserProfileClick(_ sender: Any) {
        if (item.user?.id != BaseData.getInstance().getCurrentUser().id) {
            self.delegate?.onUserProfileClick(user: item.user!)
        }
    }
    
}
