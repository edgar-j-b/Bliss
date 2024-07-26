//
//  LikedYouViewController.swift
//  Bliss
//
//  Created by Admin on 7/22/24.
//


import UIKit

///This file defines the LikedYouViewController class, which manages the display of users who have liked the current user in the Bliss application. It shows a list of users in a table view and allows the current user to view profiles.
///This class manages the display of users who have liked the current user.
class LikedYouViewController: UIViewController {

    //MARK: - Properties
    
    ///tableView: The table view that displays the list of users.
    @IBOutlet weak var tableView: UITableView!
    ///profilePictureIv: An image view that displays the current user's profile picture.
    @IBOutlet weak var profilePictureIv: UIImageView!
    
    ///users: An array of User objects representing the users who have liked the current user.
    var users: [User]?
    
    //MARK: - Lifecycle Methods
    ///Called after the controller's view is loaded into memory. Sets the user's profile picture and calls setupUI() to configure the table view.
    override func viewDidLoad() {
        super.viewDidLoad()

        profilePictureIv.image = UIImage(named: BaseData.getInstance().currentUser.profilePicture!)!
        setupUI()
    }
    
    //MARK: - Methods
    
    ///Configures the table view by setting its delegate and data source, registering the custom cell, and reloading the data.
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: UserItemTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: UserItemTableViewCell.identifier)
        
        users = BaseData.getInstance().peoples
        self.tableView.reloadData()
    }
    
    //MARK: - Actions
    ///Called when the profile picture is clicked. Navigates to the current user's profile using MyProfileViewController.
    @IBAction func onMyProfileClick(_ sender: Any) {
        MyProfileViewController.show(self, item: BaseData.getInstance().currentUser)
    }
    
}

//MARK: Extensions

extension LikedYouViewController: UITableViewDelegate, UITableViewDataSource {
    ///Returns the number of rows in the specified section. This is equal to the number of users who have liked the current user.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    ///Configures and returns a table view cell for the specified index path. Sets the user data for the cell and configures its appearance.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserItemTableViewCell.identifier, for: indexPath) as! UserItemTableViewCell
        cell.item = users![indexPath.row]
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
}

//MARK: - UserItemDelegate

extension LikedYouViewController: UserItemDelegate {
    ///Called when a user profile is clicked. Navigates to the Tinder-like profile view for the selected user using TinderViewController.
    func onUserProfileClick(user: User) {
        TinderViewController.show(self, user: user)
    }
}

