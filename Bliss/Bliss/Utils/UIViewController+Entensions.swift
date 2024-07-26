//
//  UIViewController+Entensions.swift
//  Bliss
//
//  Created by Admin on 7/22/24.
//

import UIKit

///Description: A key used for associating the UIScrollView with the view controller using associated objects.
private var scrollViewKey : UInt8 = 0
///Description: A typealias for a closure that handles actions for alert buttons.
typealias AlertButtonHandler = (UIAlertAction) -> Void

///This file extends UIViewController with utility methods for presenting alerts and handling keyboard notifications for scroll views. It provides functionality for showing error messages, general messages, and handling keyboard appearance to adjust scroll view insets.
extension UIViewController {
    
    ///Parameters:
    ///message: The error message to display.
    ///Description: Presents an alert with the title "Error" and the given message.
    func presentError(_ message: String) {
        let alertController = UIAlertController(title: "Error",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
    
    ///Parameters:
    ///message: The errors message to display.
    ///Description: Presents an alert with the title "Encountered Errors" and the given message.
    func presentErrors(_ message: String) {
        let alertController = UIAlertController(title: "Encountered Errors",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
    
    ///Parameters:
    ///message: The message to display.
    ///Description: Presents an alert with the title "Message" and the given message.
    func presentMessage(_ message: String) {
        let alertController = UIAlertController(title: "Message",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
    
    ///Parameters:
    ///message: The message to display.
    ///handler: A closure to handle the button action.
    ///Description: Presents an alert with the given message and an "OK" button that triggers the provided handler when tapped.
    func presentMessageWithButtonHandler(_ message: String, hanlder: @escaping AlertButtonHandler) {
        let alertController = UIAlertController(title: "",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: hanlder))
        self.present(alertController,animated: true)
    }
    
    ///Parameters:
    ///scrollView: The scroll view to adjust when the keyboard appears.
    ///Description: Sets up observers for keyboard notifications to adjust the scroll view's content inset when the keyboard appears or hides.
    public func setupKeyboardNotifcationListenerForScrollView(_ scrollView: UIScrollView) {
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        internalScrollView = scrollView
    }

    ///Description: Removes the observers for keyboard notifications.
    public func removeKeyboardNotificationListeners() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    ///Description: A property that stores the associated scroll view using Objective-C runtime.
    fileprivate var internalScrollView: UIScrollView! {
        get {
            return objc_getAssociatedObject(self, &scrollViewKey) as? UIScrollView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &scrollViewKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    ///Parameters:
    ///notification: The notification object containing information about the keyboard appearance.
    ///Description: Adjusts the scroll view's content inset and scroll indicator insets when the keyboard appears to ensure that the scroll view remains visible.
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo as! Dictionary<String, AnyObject>
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey]!.int32Value
        let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]?.cgRectValue
        let keyboardFrameConvertedToViewFrame = view.convert(keyboardFrame!, from: nil)
        let curveAnimationOption = UIView.AnimationOptions(rawValue: UInt(animationCurve!))
        let options: UIView.AnimationOptions = [.beginFromCurrentState, curveAnimationOption]
        UIView.animate(withDuration: animationDuration, delay: 0, options:options, animations: { () -> Void in
            let insetHeight = (self.internalScrollView.frame.height + self.internalScrollView.frame.origin.y) - keyboardFrameConvertedToViewFrame.origin.y
            self.internalScrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: insetHeight, right: 0)
            self.internalScrollView.scrollIndicatorInsets  = UIEdgeInsets.init(top: 0, left: 0, bottom: insetHeight, right: 0)
            }) { (complete) -> Void in
        }
    }

    ///Parameters:
    ///notification: The notification object containing information about the keyboard disappearance.
    ///Description: Resets the scroll view's content inset and scroll indicator insets when the keyboard hides.
    @objc func keyboardWillHide(_ notification: Notification) {
        let userInfo = notification.userInfo as! Dictionary<String, AnyObject>
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey]!.int32Value
        let curveAnimationOption = UIView.AnimationOptions(rawValue: UInt(animationCurve!))
        let options: UIView.AnimationOptions = [.beginFromCurrentState, curveAnimationOption]
        UIView.animate(withDuration: animationDuration, delay: 0, options:options, animations: { () -> Void in
            self.internalScrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            self.internalScrollView.scrollIndicatorInsets  = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            }) { (complete) -> Void in
        }
    }
}

