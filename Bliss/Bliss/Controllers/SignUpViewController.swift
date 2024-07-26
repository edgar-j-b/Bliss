//
//  SignUpViewController.swift
//  Bliss
//
//  Created by Admin on 7/22/24.
//


import UIKit
///RSSelectionMenu: A library for creating selection menus.
import RSSelectionMenu

///This file defines the SignUpViewController class, which manages the user sign-up interface, allowing users to enter their profile details and create a new account.
///This class handles the sign-up view, including displaying and inputting user information, selecting profile pictures, and navigating between views.
class SignUpViewController: UIViewController {
    
    //MARK: - Properties
    
    ///addProfileView: A view for adding profile-related elements.
    @IBOutlet weak var addProfileView: UIView!
    ///profilePictureView: A view containing the profile picture.
    @IBOutlet weak var profilePictureView: UIView!
    ///profilePictureIv: Image view for displaying the user's profile picture.
    @IBOutlet weak var profilePictureIv: UIImageView!
    ///scrollView: A scroll view for accommodating the sign-up view's content.
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
    ///usernameTv: Text field for the user's username.
    @IBOutlet weak var usernameTv: UITextField!
    ///passwordTv: Text field for the user's password.
    @IBOutlet weak var passwordTv: UITextField!
    ///confirmPasswordTv: Text field for confirming the user's password.
    @IBOutlet weak var confirmPasswordTv: UITextField!
    ///imagePicker: An image picker controller for selecting profile pictures.
    let imagePicker = UIImagePickerController()

    //MARK: - Lifecycle Methods
    
    ///Called after the view has been loaded into memory. Sets up keyboard notifications and configures the image picker.
    override func viewDidLoad() {
        super.viewDidLoad()

        setupKeyboardNotifcationListenerForScrollView(self.scrollView)
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
    }
    
    //MARK: - Methods
    
    ///Opens the photo library to select a profile picture.
    @IBAction func onSelectProfilePictureClick(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.image"]
        present(imagePicker, animated: true, completion: nil)
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
    
    ///Validates the passwords and navigates back to the previous view controller if they match.
    @IBAction func onSaveClick(_ sender: Any) {
        if passwordTv.text != confirmPasswordTv.text {
            self.presentError("Password is not match.")
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
///These extensions handle the image picker delegate methods.
extension SignUpViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    ///Handles the selection of a profile picture from the photo library.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        
        dismiss(animated: true, completion: nil)
        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            profilePictureIv.image = pickedImage
            addProfileView.isHidden = true
            profilePictureView.isHidden = false
        }
        
        
    }
}

//MARK: Helper Functions

///Converts a dictionary of UIImagePickerController.InfoKey to a dictionary of String.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

///Converts a UIImagePickerController.InfoKey to a String.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
