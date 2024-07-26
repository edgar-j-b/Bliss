//
//  LoginViewController.swift
//  Bliss
//
//  Created by Admin on 7/20/24.
//

import UIKit

///This file defines the LoginViewController class, which manages the login screen of the Bliss application.
///This class manages the login screen's user interface and handles user interactions related to the login process.
class LoginViewController: UIViewController {

    //MARK: Properties
    /// usernameTf: A text field for the user to enter their username.
    @IBOutlet weak var usernameTf: UITextField!
    /// passwordTf: A text field for the user to enter their password.
    @IBOutlet weak var passwordTf: UITextField!
    
     //MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: Action Methods
    
     ///Invoked when the login button is clicked.
     ///Triggers navigation to the main menu view.
    @IBAction func onLoginClick(_ sender: Any) {
        MainMenuViewController.show(self)
    }
    
}

//MARK: Extensions

///This extension provides additional functionalities related to the LoginViewController.
extension LoginViewController {
    
    
    ///Creates and returns an instance of LoginViewController from the main storyboard.
    static func create() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        return controller
    }
    
    
    ///Creates an instance of LoginViewController and presents it by setting it as the root view controller within a navigation controller.
    static func show() {
        let controller = LoginViewController.create()
        
        let nav = UINavigationController(rootViewController: controller)
        nav.isNavigationBarHidden = true;
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    
}

