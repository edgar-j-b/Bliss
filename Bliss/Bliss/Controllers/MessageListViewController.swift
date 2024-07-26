//
//  MessageListViewController.swift
//  Bliss
//
//  Created by Admin on 7/22/24.
//


import UIKit

///This file defines the MessageListViewController class, which displays a list of messages for the current user. It allows users to view their messages and navigate to detailed chat views.
///This class manages the display of messages in a table view and handles user interactions
class MessageListViewController: UIViewController {

    //MARK: - Properties
    ///tableView: The table view that displays the list of messages.
    @IBOutlet weak var tableView: UITableView!
    ///profilePictureIv: An image view that displays the current user's profile picture
    @IBOutlet weak var profilePictureIv: UIImageView!
    
    ///messages: An array of Message objects representing the list of messages for the current user.
    var messages:[Message] = []
    
    //MARK: - Lifecycle Methods
    
    ///Called after the controller's view is loaded into memory. Sets the profile picture and calls setupUI() to configure the table view.
    override func viewDidLoad() {
        super.viewDidLoad()

        profilePictureIv.image = UIImage(named: BaseData.getInstance().currentUser.profilePicture!)!
        setupUI()
    }
    
    //MARK: - Methods
    
    ///Configures the table view by setting its delegate and data source, registering the custom cell, and populating the messages array with data.
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: MessageItemTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MessageItemTableViewCell.identifier)
        
        messages = BaseData.getInstance().populateMessages()
        self.tableView.reloadData()
    }
    
    //MARK: - Actions

    ///Called when the profile picture is clicked. Navigates to the current user's profile using MyProfileViewController.
    @IBAction func onMyProfileClick(_ sender: Any) {
        MyProfileViewController.show(self, item: BaseData.getInstance().currentUser)
    }
    
}

//MARK: - Extensions

extension MessageListViewController : UITableViewDelegate, UITableViewDataSource {
    
    ///Returns the number of rows in the table view, which is equal to the number of messages.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    ///Configures and returns a table view cell for the specified index path. Sets the message data for the cell and configures its appearance.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageItemTableViewCell.identifier, for: indexPath) as! MessageItemTableViewCell
        cell.item = messages[indexPath.row]
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        cell.selectionStyle = .none
        return cell
    }
    
    ///Called when a row is selected. Navigates to the chat view for the selected message using ChatMainViewController.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ChatMainViewController.show(self, item: messages[indexPath.row])
        
    }
}

