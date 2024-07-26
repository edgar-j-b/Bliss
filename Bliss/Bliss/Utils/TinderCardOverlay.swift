//
//  TinderCardOverlay.swift
//  Bliss
//
//  Created by Admin on 7/20/24.
//

///Shuffle_iOS: Provides functionality for swipeable card interfaces.
import Shuffle_iOS
import UIKit

///This file defines the TinderCardOverlay class, which creates and manages overlay views for different swipe directions in a Tinder-like swipeable card interface. It uses custom overlay labels to indicate swipe actions such as left, right, or up.
class TinderCardOverlay: UIView {
    
    ///Parameters:
    ///direction: The direction of the swipe (left, right, up, or other).
    ///Description: Initializes the overlay view based on the specified swipe direction by calling the appropriate method to create the overlay for that direction.
    init(direction: SwipeDirection) {
        super.init(frame: .zero)
        switch direction {
        case .left:
            createLeftOverlay()
        case .up:
            createUpOverlay()
        case .right:
            createRightOverlay()
        default:
            break
        }
    }
    
    ///Description: Required initializer that returns nil since this class does not support initialization from a storyboard or nib file.
    required init?(coder: NSCoder) {
        return nil
    }
    
    //MARK: Private Methods
    ///Description: Configures the overlay for a left swipe direction. Adds a TinderCardOverlayLabelView with the title "NOPE" and a red color, rotated to the left.
    ///
    private func createLeftOverlay() {
        let leftTextView = TinderCardOverlayLabelView(withTitle: "NOPE",
                                                      color: .sampleRed,
                                                      rotation: CGFloat.pi / 10)
        addSubview(leftTextView)
        leftTextView.anchor(top: topAnchor,
                            right: rightAnchor,
                            paddingTop: 30,
                            paddingRight: 14)
    }
    
    ///Description: Configures the overlay for an upward swipe direction. Adds a TinderCardOverlayLabelView with the title "LOVE" and a blue color, rotated slightly to the right.
    private func createUpOverlay() {
        let upTextView = TinderCardOverlayLabelView(withTitle: "LOVE",
                                                    color: .sampleBlue,
                                                    rotation: -CGFloat.pi / 20)
        addSubview(upTextView)
        upTextView.anchor(bottom: bottomAnchor, paddingBottom: 20)
        upTextView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    ///Description: Configures the overlay for a right swipe direction. Adds a TinderCardOverlayLabelView with the title "LIKE" and a green color, rotated to the right.
    private func createRightOverlay() {
        let rightTextView = TinderCardOverlayLabelView(withTitle: "LIKE",
                                                       color: .sampleGreen,
                                                       rotation: -CGFloat.pi / 10)
        addSubview(rightTextView)
        rightTextView.anchor(top: topAnchor,
                             left: leftAnchor,
                             paddingTop: 26,
                             paddingLeft: 14)
    }
}

private class TinderCardOverlayLabelView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    ///Parameters:
    ///title: The text to display on the label.
    ///color: The color of the label and border.
    ///rotation: The rotation angle for the label view.
    ///Description: Initializes the overlay label view with a specified title, border color, and rotation. Adds a UILabel to the view and applies the specified attributes.
    init(withTitle title: String, color: UIColor, rotation: CGFloat) {
        super.init(frame: CGRect.zero)
        layer.borderColor = color.cgColor
        layer.borderWidth = 4
        layer.cornerRadius = 4
        transform = CGAffineTransform(rotationAngle: rotation)
        
        addSubview(titleLabel)
        titleLabel.textColor = color
        titleLabel.attributedText = NSAttributedString(string: title,
                                                       attributes: NSAttributedString.Key.overlayAttributes)
        titleLabel.anchor(top: topAnchor,
                          left: leftAnchor,
                          bottom: bottomAnchor,
                          right: rightAnchor,
                          paddingLeft: 8,
                          paddingRight: 3)
    }
    
    ///Description: Required initializer that returns nil since this class does not support initialization from a storyboard or nib file.
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

extension NSAttributedString.Key {
    
    ///Description: Provides custom text attributes for overlay labels, including font and letter spacing.
    static var overlayAttributes: [NSAttributedString.Key: Any] = [
        // swiftlint:disable:next force_unwrapping
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 42)!,
        NSAttributedString.Key.kern: 5.0
    ]
}

///Description: Defines custom colors used for the overlay labels:
extension UIColor {
    ///sampleRed: A red color used for the "NOPE" label.
    static var sampleRed = UIColor(red: 252 / 255, green: 70 / 255, blue: 93 / 255, alpha: 1)
    ///sampleGreen: A green color used for the "LIKE" label.
    static var sampleGreen = UIColor(red: 49 / 255, green: 193 / 255, blue: 109 / 255, alpha: 1)
    ///sampleBlue: A blue color used for the "LOVE" label.
    static var sampleBlue = UIColor(red: 52 / 255, green: 154 / 255, blue: 254 / 255, alpha: 1)
}
