//
//  UIView+Extensions.swift
//  Bliss
//
//  Created by Admin on 7/20/24.
//


import UIKit

///This file provides extensions to UIView that simplify the process of adding constraints and applying shadows to views. These extensions help in making the layout code cleaner and more readable.
extension UIView {
    
    ///Anchors the view to the specified anchors with optional padding and size constraints.
    ///Parameters:
    ///top: The top anchor to constrain the view's top anchor to.
    ///left: The left anchor to constrain the view's left anchor to.
    ///bottom: The bottom anchor to constrain the view's bottom anchor to.
    ///right: The right anchor to constrain the view's right anchor to.
    ///paddingTop: The padding to apply at the top anchor.
    ///paddingLeft: The padding to apply at the left anchor.
    ///paddingBottom: The padding to apply at the bottom anchor.
    ///paddingRight: The padding to apply at the right anchor.
    ///width: The width constraint for the view.
    ///height: The height constraint for the view.
    ///Returns:
    ///An array of NSLayoutConstraint objects that were created and activated.
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat = 0,
                height: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: paddingTop))
        }
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: paddingLeft))
        }
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom))
        }
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -paddingRight))
        }
        if width > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: width))
        }
        if height > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: height))
        }
        
        anchors.forEach { $0.isActive = true }
        
        return anchors
    }
    
    ///Anchors the view to its superview's edges.
    ///Returns:
    ///An array of NSLayoutConstraint objects that were created and activated.
    @discardableResult
    func anchorToSuperview() -> [NSLayoutConstraint] {
        return anchor(top: superview?.topAnchor,
                      left: superview?.leftAnchor,
                      bottom: superview?.bottomAnchor,
                      right: superview?.rightAnchor)
    }
}

extension UIView {
    
    ///Applies a shadow to the view with the specified parameters.
    ///Parameters:
    ///radius: The blur radius used to create the shadow.
    ///opacity: The opacity of the shadow.
    ///offset: The offset (in points) of the shadow.
    ///color: The color of the shadow. The default color is black.

    func applyShadow(radius: CGFloat,
                     opacity: Float,
                     offset: CGSize,
                     color: UIColor = .black) {
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
    }
}

