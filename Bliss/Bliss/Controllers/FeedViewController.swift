//
//  FeedViewController.swift
//  Bliss
//
//  Created by Admin on 7/20/24.
//



import UIKit
///RSSelectionMenu: A library for selection menus with search functionality.
import RSSelectionMenu

///This file defines the FeedViewController class, which manages the feed screen of the Bliss application.
///This class manages the feed screen's user interface and handles interactions with the feed items.
class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    //MARK: Properties
    ///tableView: The table view that displays the feed items.
    @IBOutlet weak var tableView: UITableView!
    ///feeds: An array of Feed objects representing the data displayed in the feed.
    private var feeds: [Feed] = []
    
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupData()
        
    }
    
    //MARK: Setup Methods
    
    
    ///Sets up the user interface, including registering the custom table view cell.
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: FeedItemTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FeedItemTableViewCell.identifier)
    }
    
    ///Sets up the initial data for the feed items and reloads the table view.
    func setupData() {
        let user1 = User(id: 1, firstName: "Chelsea", lastName: "Brags", profilePicture: "sample_user_1", likes: nil, age: 23, occupation: "Graphic Designer", gender: "Female")
        let user2 = User(id: 2, firstName: "Josie", lastName: "Brags", profilePicture: "sample_user_2", likes: nil, age: 22, occupation: "Model/Photographer", gender: "Female")
        let comment = FeedComment(id: 1, comment: "Nice Picture", user: user1)
        let user1_feed1 = Feed(id: 1, user: user1, photoUrl: "sample_feed_user_1_1", created: "3 HOURS AGO", activty: "Added a Photo", likes: nil,comments: nil, isLike: false)
        let user1_feed2 = Feed(id: 2, user: user1, photoUrl: "sample_feed_user_1_2", created: "JUST NOW", activty: "Added a Photo", likes: [BaseData.getInstance().getCurrentUser()], comments: nil, isLike: true)
        let user2_feed1 = Feed(id: 3, user: user2, photoUrl: "sample_feed_user_2_1", created: "1 HOUR AGO", activty: "Added a Photo", likes: [user1], comments: [comment], isLike: false)
        feeds = [user1_feed2,user2_feed1,user1_feed1]
        self.tableView.reloadData()
    }
    
    //MARK: UITableViewDataSource Methods
    
    ///Returns the number of rows in the table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    ///Configures and returns the cell for the given index path.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedItemTableViewCell.identifier, for: indexPath) as! FeedItemTableViewCell
        cell.item = feeds[indexPath.row]
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        cell.selectionStyle = .none
        cell.delegate = self
        cell.index = indexPath.row
        return cell
    }
    
}

//MARK: Extensions

///This extension handles the delegate methods for the feed item interactions.
extension FeedViewController: FeedItemDelegate {
    
    ///Invoked when the "Add Comment" button is clicked. Shows the comment view controller.
    func onAddCommentClick(item: Feed, view: FeedItemTableViewCell) {
        CommentViewController.show(self, didAddCommentClick: true, item: item,delegate: self,tag: view.index!)
    }
    
    
    ///Invoked when the "Show Comment" button is clicked. Shows the comment view controller.
    func onShowCommentClick(item: Feed, view: FeedItemTableViewCell) {
        CommentViewController.show(self, didAddCommentClick: false, item: item,delegate: self,tag: view.index!)
    }
    
    ///Handles the like and dislike actions for a feed item.
    func onLikeDislikeFeed(isLiked: Bool, view: FeedItemTableViewCell) {
        if isLiked == true {
            if feeds[view.index!].likes == nil {
                feeds[view.index!].likes = [BaseData.getInstance().getCurrentUser()]
            }
            else {
                feeds[view.index!].likes?.append(BaseData.getInstance().getCurrentUser())
            }
            
        }
        else {
            var itemIndex = -1
            
            for (i,item) in feeds[view.index!].likes!.enumerated() {
                if item.id == BaseData.getInstance().getCurrentUser().id {
                    itemIndex = i
                }
            }
            
            if itemIndex > -1 {
                feeds[view.index!].likes?.remove(at: itemIndex)
            }
        }
        feeds[view.index!].isLike = isLiked
        self.tableView.reloadData()
    }
    
    ///Invoked when the "View Likes" button is clicked. Shows the likes view controller.
    func onViewLikesClick(item: Feed) {
        LikesViewController.show(self, item: item)
    }
    
    ///Invoked when a user profile is clicked. Shows the user profile in the Tinder view controller.
    func onUserProfileClick(user: User) {
        TinderViewController.show(self, user: user)
    }
    
    
    ///Invoked when the "Share" button is clicked. Shows the share menu using RSSelectionMenu.
    func onShareClick(item: Feed) {
        let lookup = BaseData.getInstance().peoples
        let taskIsForLookup = lookup.sorted(by: { ($0.getFullname() ?? "").lowercased() <  ($1.getFullname() ?? "").lowercased()})
        
        let selectionMenu = RSSelectionMenu(dataSource: taskIsForLookup) { (cell, item, indexPath) in
            cell.textLabel?.text = item.getFullname()
        }
        selectionMenu.leftBarButtonTitle = "Close"
        selectionMenu.title = "Share"
        selectionMenu.dismissAutomatically = true
        selectionMenu.setSelectedItems(items:[])  { [weak self] (item, index, isSelected, selectedItems) in
    
        }
        
        selectionMenu.showSearchBar { (searchText) -> (FilteredDataSource<User>) in
            return taskIsForLookup.filter({ ($0.getFullname()).lowercased().contains(searchText.lowercased()) })
        }
        selectionMenu.show(style: .present, from: self)
    }
}

extension FeedViewController: CommentDelegate {
    
    ///Invoked when a comment is added. Updates the feed item with the new comment and reloads the table view.
    func commentAdded(comment: FeedComment, tag: Int) {
        if feeds[tag].comments == nil {
            feeds[tag].comments = [comment]
        }
        else {
            feeds[tag].comments?.append(comment)
        }
        self.tableView.reloadData()
    }
}
