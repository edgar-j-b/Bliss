//
//  MainMenuViewController.swift
//  Bliss
//
//  Created by Admin on 7/22/24.
//

import UIKit

///This class handles the main view of the applications. its shows all the items available in the app via tab bar
class MainMenuViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}

extension MainMenuViewController {
    static func create() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainMenuViewController") as! MainMenuViewController
        
        return controller
    }
    
    static func show(_ viewController: UIViewController) {
        let controller = MainMenuViewController.create()
        
        let nav = UINavigationController(rootViewController: controller)
        nav.isNavigationBarHidden = true;
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    
}

