//
//  LikesViewController.swift
//  Bliss
//
//  Created by Admin on 7/20/24.
//


import UIKit

///This file defines the LikesViewController class, which manages the interface for displaying the list of users who liked a specific feed item in the Bliss application.
///This class manages the interface for viewing the list of users who liked a specific feed item.
class LikesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Properties
    ///tableView: Displays the list of users who liked the feed item.
    @IBOutlet weak var tableView: UITableView!
    ///item: The feed item whose likes are being displayed.
    var item: Feed?
    
    //MARK: - Lifecycle Methods
    ///Called after the controller's view is loaded into memory. Initializes the UI components.
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    ///Sets up the UI components and their properties. Registers the table view cell and reloads the table view data.
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: UserItemTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: UserItemTableViewCell.identifier)
        
        self.tableView.reloadData()
    }

    //MARK: - UITableViewDataSource Methods
    
    ///Returns the number of rows in the table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item?.likes?.count ?? 0
    }
    
    ///Configures and returns the cell for the specified row in the table view.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserItemTableViewCell.identifier, for: indexPath) as! UserItemTableViewCell
        cell.item = item?.likes![indexPath.row]
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
}

//MARK: - UserItemDelegate Methods
extension LikesViewController: UserItemDelegate {
    ///Called when the user profile is clicked. Shows the user's profile.
    func onUserProfileClick(user: User) {
        TinderViewController.show(self, user: user)
    }
}

extension LikesViewController {
    ///Creates and returns an instance of LikesViewController from the storyboard.
    static func create() -> LikesViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LikesViewController") as! LikesViewController
        
        return controller
    }
    
    ///Shows the LikesViewController as a popover with the specified feed item.
    static func show(_ viewController: UIViewController, item: Feed?) {
        let controller = LikesViewController.create()
        controller.item = item
        controller.modalPresentationStyle = .popover
        viewController.present(controller, animated: true, completion: nil)
    }
    
}
