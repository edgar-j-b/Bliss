//
//  PagingViewController.swift
//  Bliss
//
//  Created by Admin on 7/20/24.
//


import UIKit
///LZViewPager: A custom library used for creating paging views.
import LZViewPager

///This file defines the PagingViewController class, which manages the paging interface for the Bliss application. It allows users to switch between different view controllers (Feed, Leaderboard, and Forum) using a tab-like interface.
///This class manages the paging interface's user interface and handles interactions with the different pages.
class PagingViewController: UIViewController, LZViewPagerDelegate, LZViewPagerDataSource  {
    
    // MARK: - Outlets
    ///viewPager: The view pager that manages the different view controllers.
    @IBOutlet weak var viewPager: LZViewPager!
    ///profilePictureIv: An image view that displays the user's profile picture.
    @IBOutlet weak var profilePictureIv: UIImageView!
    
    // MARK: - Variables
    ///subControllers: An array of UIViewController objects representing the different pages (Feed, Leaderboard, Forum).
    private var subControllers:[UIViewController] = []
    
    // MARK: - Lifecycle Methods
    
    ///Called after the controller's view is loaded into memory. Initializes the view pager properties and sets the profile picture.
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPagerProperties()
        
        profilePictureIv.image = UIImage(named: BaseData.getInstance().currentUser.profilePicture!)!
        
    }
    
    
    // MARK: - Propertires
    
    ///Sets up the properties of the view pager and initializes the subControllers with instances of FeedViewController, LeaderboardViewController, and ForumViewController.
    func viewPagerProperties() {
        viewPager.delegate = self
        viewPager.dataSource = self
        viewPager.hostController = self
        
        let vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
        vc1.title = "Feed"
        let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeaderboardViewController") as! LeaderboardViewController
        vc2.title = "Leaderboard"
        
        let vc3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForumViewController") as! ForumViewController
        vc3.title = "Forum"
        
        subControllers = [vc1, vc2,vc3]
        viewPager.reload()
        
    }
    
    ///Returns the number of items (view controllers) in the view pager.
    func numberOfItems() -> Int {
        return subControllers.count
    }
    
    ///Returns the view controller at the specified index.
    func controller(at index: Int) -> UIViewController {
        return subControllers[index]
    }
    
    ///Returns a button configured with the title of the view controller at the specified index. The button's appearance changes based on its selection state.
    func button(at index: Int) -> UIButton {
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        let title = self.subControllers[index].title ?? ""
        let norAttrStr = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
        let selAttrStr = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
        button.setAttributedTitle(norAttrStr, for: .normal)
        button.setAttributedTitle(selAttrStr, for: .selected)
        
        return button
    }
    
    ///Returns the color of the indicator at the specified index.
    func colorForIndicator(at index: Int) -> UIColor {
        return .lightGray
    }
    
    ///Returns the corner radius of the indicator.
    func cornerRadiusForIndicator() -> CGFloat {
        return 4.0
    }
    
    ///Determines whether the view pager should enable swipe gestures. Returns false.
    func shouldEnableSwipeable() -> Bool {
        return false
    }
    
    ///Returns the height of the separator between the tabs.
    func heightForSeparator() -> CGFloat {
        return 12.0
    }
    
    
    // MARK: - Actions
    ///Called when the user clicks on the profile picture. Shows the profile view controller with the current user's profile.
    @IBAction func onMyProfileClick(_ sender: Any) {
        MyProfileViewController.show(self, item: BaseData.getInstance().currentUser)
    }
}

extension PagingViewController {
    ///Creates and returns an instance of PagingViewController from the storyboard.
    static func create() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PagingViewController") as! PagingViewController
        
        return controller
    }
    
    ///Shows the PagingViewController as the root view controller within a navigation controller.
    static func show(_ viewController: UIViewController) {
        let controller = PagingViewController.create()
        
        let nav = UINavigationController(rootViewController: controller)
        nav.isNavigationBarHidden = true;
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    
}
