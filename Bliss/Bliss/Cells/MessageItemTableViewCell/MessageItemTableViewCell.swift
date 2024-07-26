//
//  MessageItemTableViewCell.swift
//  Bliss
//
//  Created by Admin on 7/22/24.
//

import UIKit

///MessageItemTableViewCell is a custom UITableViewCell used to display message information in a table view. It shows the profile photo of the message recipient, their full name, and the last chat message.
class MessageItemTableViewCell: UITableViewCell {
    
    ///A static identifier used for dequeuing instances of this cell in a table view. The default value is "MessageItemTableViewCell".
    static let identifier = "MessageItemTableViewCell"
    ///An IBOutlet connected to an UIImageView that displays the recipient's profile photo.
    @IBOutlet weak var profilePhotoIv: UIImageView!
    ///An IBOutlet connected to a UILabel that displays the recipient's full name.
    @IBOutlet weak var nameLbl: UILabel!
    ///An IBOutlet connected to a UILabel that displays the last chat message.
    @IBOutlet weak var commentLbl: UILabel!
    
    ///A property representing the message item to be displayed in the cell. The property is observed for changes, and when set, it updates the profilePhotoIv, nameLbl, and commentLbl with the message details. The profile photo and name are extracted from the first recipient in the recipients array, and the last chat message is displayed in commentLbl.
    public var item: Message! {
        didSet {
            if let recipients = item.recipients {
                
                if recipients.count > 0 {
                    let user = recipients[0]
                    profilePhotoIv.image = UIImage(named: user.profilePicture!)
                    nameLbl.text = user.getFullname()
                }
                
            }
            
            commentLbl.text = item.lastChat
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

}
