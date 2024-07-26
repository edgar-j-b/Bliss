//
//  TinderCardFooterView.swift
//  Bliss
//
//  Created by Admin on 7/20/24.
//

import UIKit
///This file defines the TinderCardFooterView class, which is a custom UIView designed to display a title and subtitle with a gradient background, commonly used as a footer for card views.
class TinderCardFooterView: UIView {
    
    //MARK: Properties
    ///label: A UILabel instance used to display the title and subtitle text.
    private var label = UILabel()
    ///gradientLayer: An optional CAGradientLayer that can be used to create a gradient background for the view.
    private var gradientLayer: CAGradientLayer?
    
    //MARK: Initializer
    ///Initializes the TinderCardFooterView with an optional title and subtitle.
    ///Parameters:
    ///title: The title text to be displayed.
    ///subtitle: The subtitle text to be displayed.
    init(withTitle title: String?, subtitle: String?) {
        super.init(frame: CGRect.zero)
        backgroundColor = .clear
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 10
        clipsToBounds = true
        isOpaque = false
        initialize(title: title, subtitle: subtitle)
    }
    
    ///This initializer is required by UIView. It returns nil because the view is intended to be used programmatically.
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    //MARK: Private Methods
    ///Sets up the TinderCardFooterView with the provided title and subtitle.
    ///Parameters:
    ///title: The title text to be displayed.
    ///subtitle: The subtitle text to be displayed.
    ///Details:
    ///The method creates an attributed string for the title and subtitle with specific styles.
    ///If the subtitle is provided and not empty, it adds a paragraph style with line spacing and sets the number of lines for the label to 2.
    ///The label's attributed text is set, and the label is added to the view's subviews.
    private func initialize(title: String?, subtitle: String?) {
        let attributedText = NSMutableAttributedString(string: (title ?? "") + "\n",
                                                       attributes: NSAttributedString.Key.titleAttributes)
        if let subtitle = subtitle, !subtitle.isEmpty {
            attributedText.append(NSMutableAttributedString(string: subtitle,
                                                            attributes: NSAttributedString.Key.subtitleAttributes))
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            paragraphStyle.lineBreakMode = .byTruncatingTail
            attributedText.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle],
                                         range: NSRange(location: 0, length: attributedText.length))
            label.numberOfLines = 2
        }
        
        label.attributedText = attributedText
        addSubview(label)
    }
    
    //MARK: Override Methods
    ///Lays out the subviews of the TinderCardFooterView.
    ///Details:
    ///Sets the frame of the label with a specific padding from the edges of the view.
    override func layoutSubviews() {
        let padding: CGFloat = 20
        label.frame = CGRect(x: padding,
                             y: bounds.height - label.intrinsicContentSize.height - padding,
                             width: bounds.width - 2 * padding,
                             height: label.intrinsicContentSize.height)
    }
}

//MARK: Extensions
///Adds custom attributes for styling the title and subtitle text.
extension NSAttributedString.Key {
    ///shadowAttribute: Defines a shadow style for text with an offset, blur radius, and color.
    static var shadowAttribute: NSShadow = {
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        shadow.shadowBlurRadius = 2
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.3)
        return shadow
    }()
    
    ///titleAttributes: Defines attributes for the title text, including font, color, and shadow.
    static var titleAttributes: [NSAttributedString.Key: Any] = [
        // swiftlint:disable:next force_unwrapping
        NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 24)!,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.shadow: NSAttributedString.Key.shadowAttribute
    ]
    
    ///subtitleAttributes: Defines attributes for the subtitle text, including font, color, and shadow.
    static var subtitleAttributes: [NSAttributedString.Key: Any] = [
        // swiftlint:disable:next force_unwrapping
        NSAttributedString.Key.font: UIFont(name: "Arial", size: 17)!,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.shadow: NSAttributedString.Key.shadowAttribute
    ]
}
