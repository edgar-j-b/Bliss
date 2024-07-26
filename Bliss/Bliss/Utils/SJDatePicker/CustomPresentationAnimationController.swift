//
//  CustomPresentationAnimationController.swift
//  SJDatePicker
//
//  Created by Sabrina on 2017/4/13.
//  Copyright © 2017年 Sabrina. All rights reserved.
//


import UIKit

///This file defines the CustomPresentationAnimationController class, which is responsible for managing custom animations for presenting and dismissing view controllers.
///This class handles custom animations for the presentation and dismissal of view controllers.
class CustomPresentationAnimationController: NSObject,UIViewControllerAnimatedTransitioning {

    //MARK: Properties
    ///Indicates whether the animation is for presenting (true) or dismissing (false).
    let isPresenting:Bool
    ///The duration of the animation in seconds.
    let duration:TimeInterval = 0.5
    
    
    //MARK: Initializer
    ///Initializes the CustomPresentationAnimationController with the specified presentation state.
    init(isPresenting:Bool){
        self.isPresenting = isPresenting
        super.init()
    }
    
    //MARK: Methods
    ///Returns the duration of the transition animation.
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    ///Executes the appropriate animation based on the presentation state.
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentationWithTransitionContext(transitionContext: transitionContext)
        }else{
            animateDismissWithTransitionContext(transitionContext: transitionContext)
        }
    }

    //MARK: Private Methods
    ///Animates the presentation of the view controller by sliding it up from the bottom of the screen.
    private func animatePresentationWithTransitionContext(transitionContext:UIViewControllerContextTransitioning){
        guard
            let presentedController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }

        let containerView = transitionContext.containerView
        
        presentedControllerView.frame = transitionContext.finalFrame(for: presentedController)
        presentedControllerView.center.y += containerView.bounds.size.height
        containerView.addSubview(presentedControllerView)
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
            presentedControllerView.center.y -= containerView.bounds.size.height
        }) { (completed) in
            transitionContext.completeTransition(completed)
        }
    }
    
    ///Animates the dismissal of the view controller by sliding it down to the bottom of the screen.
    private func animateDismissWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
                return
        }
        
        let containerView = transitionContext.containerView
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
            presentedControllerView.center.y += containerView.bounds.size.height
        }) { (completed) in
            transitionContext.completeTransition(completed)
        }
    }
}














