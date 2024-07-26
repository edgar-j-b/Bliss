//
//  UserItemTableViewCell.swift
//  Bliss
//
//  Created by Admin on 7/20/24.
//

import UIKit

///A protocol defining a delegate method for handling user profile click events.
protocol UserItemDelegate {
    /// Notifies the delegate when a user profile is clicked.
    func onUserProfileClick(user: User)
}

///UserItemTableViewCell is a custom UITableViewCell designed to display user information in a table view. It shows the user's profile photo and full name. This cell also provides functionality to handle profile click events through a delegate.
class UserItemTableViewCell: UITableViewCell {
    
    ///A static identifier used for dequeuing instances of this cell in a table view. The default value is "UserItemTableViewCell".
    static let identifier = "UserItemTableViewCell"
    ///An IBOutlet connected to an UIImageView that displays the user's profile photo.
    @IBOutlet weak var profilePhotoIv: UIImageView!
    ///An IBOutlet connected to a UILabel that displays the user's full name.
    @IBOutlet weak var nameLbl: UILabel!
    ///A delegate conforming to the UserItemDelegate protocol. It is used to handle user profile click events.
    var delegate: UserItemDelegate?
    ///A property representing the user to be displayed in the cell. When set, it updates the profilePhotoIv and nameLbl with the user's profile picture and full name, respectively.
    public var item: User! {
        didSet {
            profilePhotoIv.image = UIImage(named: item.profilePicture!)
            nameLbl.text = item.getFullname()
        }
    }
    
    /// Called after the view has been loaded from the nib file. This method is used to perform any additional setup after the cell has been loaded. The default implementation calls the superclass's awakeFromNib() method.
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /// Called when the cell is selected or deselected. This method allows for additional configuration when the cell's selection state changes.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    ///Called when the user profile button is clicked. This method checks if the user is not the current user (obtained from BaseData.getInstance().getCurrentUser()) and, if so, notifies the delegate about the user profile click event by calling onUserProfileClick(user:).
    @IBAction func onUserProfileClick(_ sender: Any) {
        if (item.id != BaseData.getInstance().getCurrentUser().id) {
            self.delegate?.onUserProfileClick(user: item)
        }
    }
}
