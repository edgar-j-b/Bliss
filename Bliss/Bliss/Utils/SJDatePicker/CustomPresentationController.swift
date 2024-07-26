//
//  CustomPresentationController.swift
//  SJDatePicker
//
//  Created by Sabrina on 2017/4/12.
//  Copyright © 2017年 Sabrina. All rights reserved.
//


import UIKit

///This file defines the CustomPresentationController class, which is responsible for managing the presentation and dismissal transitions of a view controller with custom animations and layouts.
///This class handles custom presentation and dismissal transitions of a view controller.
class CustomPresentationController: UIPresentationController {

    //MARK: Properties
    ///The left padding of the presented view.
    static let viewLeftPadding:CGFloat = 0
    ///The top padding of the presented view.
    static let viewTopPadding:CGFloat = 170
    ///The height of the presented view.
    static let viewHeight:CGFloat = 261
    ///The top padding of the button.
    static let buttonTopPadding:CGFloat = 80
    ///The height of the button.
    static let buttonHeight:CGFloat = 40
    ///A button used to create a dimming view effect during presentation.
    var dimmingView:UIButton = UIButton.init()
    
    //MARK: Methods
    ///Prepares the dimming view and animates its appearance when the presentation transition begins.
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {
            return
        }
        
        dimmingView.frame = containerView.bounds
        dimmingView.backgroundColor = UIColor.black
        dimmingView.alpha = 0.0
        dimmingView.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        containerView.addSubview(dimmingView)

        if let transitionCoordinator = presentedViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { (context) in
                self.dimmingView.alpha = 0.5
            }, completion: nil)
        }
    }
    
    ///Removes the dimming view if the presentation transition did not complete.
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    ///Animates the disappearance of the dimming view when the dismissal transition begins.
    override func dismissalTransitionWillBegin() {
        if let transitionCoordinator = presentedViewController.transitionCoordinator{
            transitionCoordinator.animate(alongsideTransition: { (context) in
                self.dimmingView.alpha = 0.0
            }, completion: nil)
        }
    }
    
    ///Removes the dimming view if the dismissal transition did not complete.
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmingView.removeFromSuperview()
        }
    }

    ///Calculates and returns the frame of the presented view within the container view.
    override var frameOfPresentedViewInContainerView:CGRect {
        guard let containerView = containerView else {
            print("Not find view")
            return CGRect()
        }
        
        var frame = containerView.bounds
        frame = frame.insetBy(dx: CustomPresentationController.viewLeftPadding, dy: CustomPresentationController.viewTopPadding)
        frame.origin.y = containerView.bounds.size.height - CustomPresentationController.viewHeight - CustomPresentationController.buttonTopPadding - CustomPresentationController.viewLeftPadding - containerView.safeAreaInsets.bottom + 12
        
        frame.size.height = CustomPresentationController.viewHeight + CustomPresentationController.buttonTopPadding
        
        return frame
    }
    
    ///Dismisses the presented view controller when the dimming view is tapped.
    @objc func dismissSelf(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    
}
