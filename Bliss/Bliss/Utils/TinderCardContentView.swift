//
//  TinderCardContentView.swift
//  Bliss
//
//  Created by Admin on 7/20/24.
//


import UIKit

///This file defines a custom UIView subclass called TinderCardContentView, which is designed to display an image with a gradient overlay, similar to a card view used in the Tinder app. The view includes rounded corners and shadow effects.
///A custom UIView subclass that displays an image with a gradient overlay.
class TinderCardContentView: UIView {
    
    //MARK: Properties
    ///A UIView that serves as the background of the card. It has rounded corners and clips its content to its bounds.
    private let backgroundView: UIView = {
        let background = UIView()
        background.clipsToBounds = true
        background.layer.cornerRadius = 10
        return background
    }()
    
    ///An UIImageView that displays the image in the card. It uses the .scaleAspectFill content mode to ensure the image fills the view while maintaining its aspect ratio.
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    ///A CAGradientLayer that overlays the imageView to create a gradient effect from top to bottom.
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.withAlphaComponent(0.01).cgColor,
                           UIColor.black.withAlphaComponent(0.8).cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        return gradient
    }()
    
    //MARK: Initializers
    
    ///Initializes the view with an optional image. It calls the initialize() method to set up the view hierarchy and appearance.
    init(withImage image: UIImage?) {
        super.init(frame: .zero)
        imageView.image = image
        initialize()
    }
    
    ///Required initializer that returns nil because the view is not designed to be initialized from a storyboard or nib.
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    //MARK: Methods
    ///Sets up the view by adding subviews and applying constraints and shadow effects. The gradient layer is added above the imageView layer.
    private func initialize() {
        addSubview(backgroundView)
        backgroundView.anchorToSuperview()
        backgroundView.addSubview(imageView)
        imageView.anchorToSuperview()
        applyShadow(radius: 8, opacity: 0.2, offset: CGSize(width: 0, height: 2))
        backgroundView.layer.insertSublayer(gradientLayer, above: imageView.layer)
    }
    
    ///Overrides the draw(_:) method to set the frame of the gradientLayer based on the view’s bounds. The gradient covers the bottom 35% of the view.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let heightFactor: CGFloat = 0.35
        gradientLayer.frame = CGRect(x: 0,
                                     y: (1 - heightFactor) * bounds.height,
                                     width: bounds.width,
                                     height: heightFactor * bounds.height)
    }
}

