//
//  SJDatePicker.swift
//  SJDatePicker
//
//  Created by sabrina on 2020/11/19.
//  Copyright © 2020 Sabrina. All rights reserved.
//


import Foundation
import UIKit

///Defines a typealias for a tuple containing start and end CGPoint.
typealias DirectionPoint = (start: CGPoint, end: CGPoint)

///This file defines the SJDatePicker class, a custom subclass of UIDatePicker that supports additional styling and customization.
///Inherits from UIDatePicker and provides additional customization and styling options.
class SJDatePicker:UIDatePicker {
    
    //MARK: Properties
    ///screenScale: A computed property that returns the scale factor of the screen.
    private var screenScale: CGFloat { UIScreen.main.scale }
    ///highlightedView: A UIView that highlights the selected date in the date picker.
    private let highlightedView:UIView = UIView()
    ///style: An optional PickerStyle that, when set, triggers the setupStyle method to apply the style to the date picker.
    var style:PickerStyle? { didSet { setupStyle() } }
    
    //MARK: Initializers
    ///Initializes the date picker with a frame and calls the initialized method.
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialized()
    }
    ///Initializes the date picker from a storyboard or nib file and calls the initialized method.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialized()
    }
    
    //MARK: Methods
    ///Configures the date picker, including setting the preferred date picker style and configuring subviews.
    private func initialized() {
        if #available(iOS 13.4, *) {
            self.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        self.subviews.forEach { (view) in
            view.subviews.forEach { (subView) in
                subView.backgroundColor = .clear
            }
        }
        self.layer.masksToBounds = true
        self.backgroundColor = .clear
        
        highlightedView.frame = .zero
        highlightedView.backgroundColor = UIColor.clear
        highlightedView.layer.borderWidth = 1.0
        self.addSubview(highlightedView)
        highlightedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([highlightedView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     highlightedView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                                     highlightedView.heightAnchor.constraint(equalToConstant: 35),
                                     highlightedView.centerYAnchor.constraint(equalTo: self.centerYAnchor)])
    
    }
    
    ///Overrides the layoutSubviews method to apply the pickerColor from the style.
    override func layoutSubviews() {
        super.layoutSubviews()
        if let text = style?.pickerColor {
            switch text {
            case .color(let color):
                self.setValue(color, forKeyPath: "textColor")
            case .colors(let colors):
                let colors = updateGradientToUIColor(colors: colors)
                self.setValue(colors, forKeyPath: "textColor")
            }
        }
    }
}

//MARK: Private Methods

private extension SJDatePicker {
    ///Applies the PickerStyle to the date picker, including setting minimum and maximum dates, the current date, time zone, picker mode, and highlight border color.
    private func setupStyle() {
        self.perform(NSSelectorFromString("setHighlightsToday:"), with: false)
        
        if let minDate = style?.minimumDate {
            self.minimumDate = minDate
        }
        
        if let maxDate = style?.maximumDate {
            self.maximumDate = maxDate
        }
        
        if let minDate = minimumDate, let maxDate = maximumDate {
            assert(minDate < maxDate, "minimum date cannot bigger then maximum date")
        }
        
        if let date = style?.date {
            self.date = date
        }
        
        if let zone = style?.timeZone {
            self.timeZone = zone
        }
        
        if let mode = style?.pickerMode {
            self.datePickerMode = mode
        }
        
        if let color = style?.textColor {
            self.highlightedView.layer.borderColor = color.cgColor
        }
    }
    
    ///Converts an array of UIColor to a single UIColor with a gradient pattern.
    private func updateGradientToUIColor(colors: [UIColor]) -> UIColor? {
        let layer = createGradientLayer(colors: colors)
        guard let image = updateGradientToUIImage(gradientLayer: layer) else { return nil }
        return UIColor(patternImage: image)
    }
    
    ///Renders a CAGradientLayer to a UIImage.
    private func updateGradientToUIImage(gradientLayer: CAGradientLayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, gradientLayer.isOpaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        gradientLayer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    ///Creates a CAGradientLayer with the provided colors and configured start and end points.
    private func createGradientLayer(colors: [UIColor]) -> CAGradientLayer {
        guard colors.count > 1 else { return CAGradientLayer() }
        let layer = CAGradientLayer()
        layer.frame = self.bounds
        layer.colors = colors.map({ $0.cgColor })
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 0.5)
        return layer
    }
}
