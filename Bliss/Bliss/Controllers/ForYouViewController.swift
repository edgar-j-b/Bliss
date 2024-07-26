//
//  ForYouViewController.swift
//  Bliss
//
//  Created by Admin on 7/22/24.
//


import UIKit

///This file defines the ForYouViewController class, which manages the display of a list of potential matches for the user in the Bliss application. The interface shows a table view of matches and allows navigation to the user's profile or chat interface.
///This class manages the display of potential matches for the user.
class ForYouViewController: UIViewController {
    
    //MARK: - Properties
    ///tableView: The table view that displays the list of matches.
    @IBOutlet weak var tableView: UITableView!
    ///profilePictureIv: An image view that displays the current user's profile picture.
    @IBOutlet weak var profilePictureIv: UIImageView!
    
    ///matches: An array of User objects representing potential matches.
    private var matches: [User] = []
    
    //MARK: - Lifecycle Methods
    ///Called after the controller's view is loaded into memory. Sets the user's profile picture and calls setupUI() to initialize the user interface.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePictureIv.image = UIImage(named: BaseData.getInstance().currentUser.profilePicture!)!
        setupUI()
    }
    
    //MARK: - Methods
    ///Sets up the user interface by configuring the table view's delegate and data source, registering the table view cell, loading matches from BaseData, and reloading the table view.
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: MatchItemTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MatchItemTableViewCell.identifier)
        
        matches = BaseData.getInstance().peoples
        self.tableView.reloadData()
    }
    
    //MARK: - Actions
    ///Called when the profile picture is clicked. Navigates to the current user's profile using MyProfileViewController.
    @IBAction func onMyProfileClick(_ sender: Any) {
        MyProfileViewController.show(self, item: BaseData.getInstance().currentUser)
    }
    
}

//MARK: - Extensions
extension ForYouViewController : UITableViewDelegate, UITableViewDataSource {
    ///Returns the number of rows (matches) in the table view section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    ///Configures and returns a table view cell for the specified row. Sets the cell's item to the corresponding match and customizes the cell's appearance.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MatchItemTableViewCell.identifier, for: indexPath) as! MatchItemTableViewCell
        cell.item = matches[indexPath.row]
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        cell.selectionStyle = .none
        return cell
    }
    
    ///Called when a row is selected. Checks if there is an existing message with the selected user and navigates to the appropriate chat interface using ChatMainViewController.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = matches[indexPath.row]
        if let message = BaseData.getInstance().checkIfAlreadyGotMessage(user: user) {
            ChatMainViewController.show(self, item: message)
        }
        else {
            ChatMainViewController.showForNewMessageFromMatch(self, item: user)
        }
        
    }
}
