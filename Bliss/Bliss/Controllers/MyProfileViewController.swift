//
//  MyProfileViewController.swift
//  Bliss
//
//  Created by Admin on 7/22/24.
//

import UIKit
///RSSelectionMenu: A library for creating selection menus.
import RSSelectionMenu

///This file defines the MyProfileViewController class, which manages the user profile interface, allowing users to view and update their profile details.
///This class handles the user profile view, including displaying and editing user information.
class MyProfileViewController: UIViewController {

    //MARK: - Properties
    
    ///addProfileView: A view for adding profile-related elements.
    @IBOutlet weak var addProfileView: UIView!
    ///profilePictureIv: Image view for displaying the user's profile picture.
    @IBOutlet weak var profilePictureIv: UIImageView!
    ///scrollView: A scroll view for accommodating the profile view's content.
    @IBOutlet weak var scrollView: UIScrollView!
    ///firstNameTv: Text field for the user's first name.
    @IBOutlet weak var firstNameTv: UITextField!
    ///lastNameTv: Text field for the user's last name.
    @IBOutlet weak var lastNameTv: UITextField!
    ///genderTv: Text field for the user's gender.
    @IBOutlet weak var genderTv: UITextField!
    ///birthdayTv: Text field for the user's birthday.
    @IBOutlet weak var birthdayTv: UITextField!
    ///genderPreferenceTv: Text field for the user's gender preference.
    @IBOutlet weak var genderPreferenceTv: UITextField!
    ///occupationTv: Text field for the user's occupation.
    @IBOutlet weak var occupationTv: UITextField!
    
    ///user: An optional User object representing the current user's profile.
    var user: User?
    
    //MARK: - Lifecycle Methods
    
    ///Called after the view has been loaded into memory. Sets up keyboard notifications and initializes the user profile.
    override func viewDidLoad() {
        super.viewDidLoad()

        setupKeyboardNotifcationListenerForScrollView(self.scrollView)
        setupUser()
    }
    
    //MARK: - Methods
    
    ///Configures the view with the current user's details.
    func setupUser() {
        addProfileView.isHidden = true
        profilePictureIv.image = UIImage(named: (user?.profilePicture)!)!
        firstNameTv.text = user?.firstName
        lastNameTv.text = user?.lastName
        genderTv.text = user?.gender
        birthdayTv.text = user?.birthday
        genderPreferenceTv.text = user?.userPreference
        occupationTv.text = user?.occupation
    }
    
    //MARK: - Actions
    
    ///Navigates back to the previous view controller.
    @IBAction func onBackBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    ///Displays a selection menu for choosing the user's gender.
    @IBAction func onGenderClick(_ sender: Any) {
        let lookup = ["Male", "Female"]
        
        let selectionMenu = RSSelectionMenu(dataSource: lookup) { (cell, item, indexPath) in
            cell.textLabel?.text = item
        }
        
        selectionMenu.setSelectedItems(items:[])  { [weak self] (item, index, isSelected, selectedItems) in
            self?.genderTv.text = item
        }
        
        selectionMenu.show(style: .popover(sourceView: (sender as! UIButton), size: nil), from: self)
    }
    
    ///Displays a date picker for selecting the user's birthday.
    @IBAction func onBirthdayClick(_ sender: Any) {
        var style = DefaultStyle()
        style.titleFont = UIFont.systemFont(ofSize: 17, weight: .bold)
        style.pickerMode = .date
        style.titleString = "Select Date and Start Time"
        style.returnDateFormat = .mmmm_dd_yyyy
        style.date = user?.birthday?.toDate(withFormat: "MMMM dd, yyyy")
        
        
        let pick:PresentedViewController = PresentedViewController()
        pick.style = style
        
        pick.block = { [weak self] (date) in
            
            self!.birthdayTv.text = date
        }
        self.present(pick, animated: true, completion: nil)
    }
    
    ///Displays a selection menu for choosing the user's gender preference.
    @IBAction func onGenderPreferenceClick(_ sender: Any) {
        let lookup = ["Male", "Female"]
        
        let selectionMenu = RSSelectionMenu(dataSource: lookup) { (cell, item, indexPath) in
            cell.textLabel?.text = item
        }
        
        selectionMenu.setSelectedItems(items:[])  { [weak self] (item, index, isSelected, selectedItems) in
            self?.genderPreferenceTv.text = item
        }
        
        selectionMenu.show(style: .popover(sourceView: (sender as! UIButton), size: nil), from: self)
    }
    
    ///Updates the user profile with new details and navigates back to the previous view controller.
    @IBAction func onUpdateClick(_ sender: Any) {
        let user = User(id: 99, firstName: firstNameTv.text, lastName: lastNameTv.text, profilePicture: "ic_current_user", age: 33, occupation: occupationTv.text, gender: genderTv.text, userPreference: genderPreferenceTv.text, birthday: birthdayTv.text)
        BaseData.getInstance().currentUser = user
        self.navigationController?.popViewController(animated: true)
    }
    
    ///Navigates to the login view controller, typically used for signing out the user.
    @IBAction func onSignOutClick(_ sender: Any) {
        
        LoginViewController.show()
    }
}

//MARK: - Extensions
extension MyProfileViewController {
    
    ///Instantiates and returns a new MyProfileViewController from the storyboard.
    static func create() -> MyProfileViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        
        return controller
    }
    
    ///Presents the MyProfileViewController with a given User object.
    static func show(_ viewController: UIViewController, item: User?) {
        let controller = MyProfileViewController.create()
        controller.user = item
        viewController.navigationController?.pushViewController(controller, animated: true)
    }
}
