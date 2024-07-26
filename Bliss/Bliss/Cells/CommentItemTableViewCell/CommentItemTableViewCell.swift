//
//  CommentItemTableViewCell.swift
//  Bliss
//
//  Created by Admin on 7/20/24.
//

import UIKit

///A protocol defining a delegate method for handling user profile click events.
protocol CommentItemDelegate {
    ///Notifies the delegate when a user profile is clicked.
    func onUserProfileClick(user: User)
}

///CommentItemTableViewCell is a custom UITableViewCell designed to display comments in a table view. It includes the user's profile photo, name, and the comment text. The cell also handles user profile click events through a delegate.
class CommentItemTableViewCell: UITableViewCell {
    ///A static identifier used for dequeuing instances of this cell in a table view. The default value is "CommentItemTableViewCell".
    static let identifier = "CommentItemTableViewCell"
    ///An IBOutlet connected to an UIImageView that displays the user's profile photo.
    @IBOutlet weak var profilePhotoIv: UIImageView!
    ///An IBOutlet connected to a UILabel that displays the user's full name.
    @IBOutlet weak var nameLbl: UILabel!
    ///An IBOutlet connected to a UILabel that displays the comment text.
    @IBOutlet weak var commentLbl: UILabel!
    ///A delegate conforming to the CommentItemDelegate protocol. It is used to handle user profile click events.
    var delegate: CommentItemDelegate?
    
    ///A property representing the comment to be displayed in the cell. When set, it updates the profilePhotoIv and nameLbl with the commenter's profile picture and full name, respectively. It also updates the commentLbl with the comment text.
    public var item: FeedComment! {
        didSet {
            if let user = item.user {
                profilePhotoIv.image = UIImage(named: user.profilePicture!)
                nameLbl.text = user.getFullname()
            }
            commentLbl.text = item.comment
        }
    }
    
    ///A property representing a user whose profile and likes are to be displayed. When set, it updates the profilePhotoIv and nameLbl with the user's profile picture and full name. It also updates the commentLbl with the number of likes if available.
    public var user: User! {
        didSet {
            profilePhotoIv.image = UIImage(named: user.profilePicture!)
            nameLbl.text = user.getFullname()
            if user.likes != nil {
                commentLbl.text = String(user.likes?.count ?? 0) + " likes"
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
    
    ///Called when the user profile button is clicked. This method determines whether to notify the delegate about the click event based on whether item or user is set. It checks if the user is not the current user (obtained from BaseData.getInstance().getCurrentUser()) and, if so, notifies the delegate about the user profile click event by calling onUserProfileClick(user:).
    @IBAction func onUserProfileClick(_ sender: Any) {
        if (item == nil && user != nil) {
            if (user.id != BaseData.getInstance().getCurrentUser().id) {
                self.delegate?.onUserProfileClick(user:user)
            }
        }
        else {
            if (item.user?.id != BaseData.getInstance().getCurrentUser().id) {
                self.delegate?.onUserProfileClick(user:item.user!)
            }
        }
        
    }
    

}
