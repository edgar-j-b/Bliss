//
//  MatchItemTableViewCell.swift
//  Bliss
//
//  Created by Admin on 7/22/24.
//

import UIKit

///MatchItemTableViewCell is a custom UITableViewCell designed for displaying user profile information in a table view. It shows a user's profile photo and full name.
class MatchItemTableViewCell: UITableViewCell {
    
    /// A static identifier used for dequeuing instances of this cell in a table view. The default value is "MatchItemTableViewCell".
    static let identifier = "MatchItemTableViewCell"
    ///An IBOutlet connected to an UIImageView that displays the user's profile photo.
    @IBOutlet weak var profilePhotoIv: UIImageView!
    ///An IBOutlet connected to a UILabel that displays the user's full name.
    @IBOutlet weak var nameLbl: UILabel!

    ///A property representing the user whose information is to be displayed in the cell. The property is observed for changes, and when set, it updates the profilePhotoIv and nameLbl with the user's profile picture and full name, respectively.
    public var item: User! {
        didSet {
            profilePhotoIv.image = UIImage(named: item.profilePicture!)
            nameLbl.text = item.getFullname()
        }
    }
    
    ///Called after the view has been loaded from the nib file. This method is used to perform any additional setup after the cell has been loaded. The default implementation calls the superclass's awakeFromNib() method.
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
