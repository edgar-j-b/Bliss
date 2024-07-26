//
//  LeaderboardViewController.swift
//  Bliss
//
//  Created by Admin on 7/20/24.
//


import UIKit

///This file defines the LeaderboardViewController class, which manages the leaderboard screen of the Bliss application.
///This class manages the leaderboard screen's user interface and handles interactions with the leaderboard items.
class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    
    ///tableView: The table view that displays the leaderboard items.
    @IBOutlet weak var tableView: UITableView!
    ///users: An array of User objects representing the users displayed in the leaderboard.
    var users:[User] = []
    
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setupData()
    }
    
    //MARK: Setup Methods
    ///Sets up the user interface, including registering the custom table view cell.
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: CommentItemTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CommentItemTableViewCell.identifier)
    }
    
    ///Sets up the initial data for the leaderboard items and reloads the table view.
    func setupData() {
        let user1 = User(id: 1, firstName: "Chelsea", lastName: "Brags", profilePicture: "sample_user_1", likes: [BaseData.getInstance().getCurrentUser()], age: 23, occupation: "Graphic Designer",gender: "Female")
        let user2 = User(id: 2, firstName: "Josie", lastName: "Brags", profilePicture: "sample_user_2", likes: [BaseData.getInstance().getCurrentUser(), user1], age: 22, occupation: "Model/Photographer", gender: "Female")
        
        users = [user1,user2].sorted(by: { ($0.likes?.count ?? 0) > ($1.likes?.count ?? 0) })
        
        
        self.tableView.reloadData()
    }

    
    //MARK: UITableViewDataSource Methods
    ///Returns the number of rows in the table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    ///Configures and returns the cell for the given index path.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentItemTableViewCell.identifier, for: indexPath) as! CommentItemTableViewCell
        cell.user = users[indexPath.row]
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
}

//MARK: Extensions
extension LeaderboardViewController: CommentItemDelegate {
    ///Invoked when a user profile is clicked. Shows the user profile in the Tinder view controller.
    func onUserProfileClick(user: User) {
        TinderViewController.show(self, user: user)
    }
}
