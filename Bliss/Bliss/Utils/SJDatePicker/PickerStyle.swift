//
//  PickerStyle.swift
//  SJDatePicker
//
//  Created by sabrina on 2020/11/19.
//  Copyright © 2020 Sabrina. All rights reserved.
//


import Foundation
import UIKit

//MARK: Extensions
///This file defines extensions, enumerations, and protocols related to the customization of a date picker component, providing various styles and formats.
///Adds computed properties to UIColor to provide background colors that adapt to the user's interface style (dark or light mode).
extension UIColor {
    static var pickBackgroundColor:UIColor {
        return UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .dark ? UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0) : .white
        }
    }
    
    static var titleBackgroundColor:UIColor {
        return UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .dark ? UIColor(red: 150/255.0, green: 217/255.0, blue: 181/255.0, alpha: 1.0) : UIColor(red: 10/255.0, green: 186/255.0, blue: 181/255.0, alpha: 1.0)
        }
    }
}

//MARK: Enumerations
///Defines various date formats for use in the date picker.
enum DateFormat:String{
    /** 日期格式：yyyy/MM/dd */
    case yyyy_m_d = "yyyy/MM/dd"
    /** 日期格式：dd/MM/yyyy */
    case d_m_yyyy = "dd/MM/yyyy"
    /** 日期格式：MM/dd/yy */
    case m_d_yy = "MM/dd/yy"
    /** 日期格式：d-MMMM-yy */
    case d_mmmm_yy = "d-MMMM-yy"
    /** 日期格式：dd-MMMM */
    case d_mmmm = "dd-MMMM"
    /** 日期格式：MMMM-yy */
    case mmmm_yy = "MMMM-yy"
    /** 日期格式：hh:mm aaa */
    case h_mm_PM = "hh:mm aaa"
    /** 日期格式：HH:mm:ss */
    case h_mm_ss = "HH:mm:ss"
    /** 日期格式：yyyy/MM/dd HH:mm:ss */
    case yyyy_To_ss = "yyyy/MM/dd HH:mm:ss"
    
    case d_mmmm_yy_h_mm_PM = "d-MMMM-yy hh:mm aa"
    
    case yyyy_mm_dd = "yyyy-MM-dd"
    
    case mmmm_dd_yyyy = "MMMM dd, yyyy"
}

///Represents different color styles, either a single color or an array of colors.
enum StyleColor {
    case color(UIColor)
    case colors([UIColor])
}

//MARK: Protocol
///Defines the properties required for customizing the appearance and behavior of a date picker.
protocol PickerStyle {
    var backColor:UIColor { get set }
    var textColor:UIColor { get set }
    var pickerColor:StyleColor? { get set }
    var timeZone:TimeZone? { get set }
    var minimumDate:Date? { get set }
    var date:Date? { get set }
    var maximumDate:Date? { get set }
    var pickerMode:UIDatePicker.Mode? { get set }
    var titleFont:UIFont? { get set }
    var returnDateFormat:DateFormat? { get set }
    var titleString:String? { get set }
}

//MARK: Structs
///Provides a default implementation of the PickerStyle protocol with pre-defined properties.
struct DefaultStyle:PickerStyle {
    var backColor: UIColor = UIColor.pickBackgroundColor
    var textColor: UIColor = UIColor.black
    var pickerColor: StyleColor? = StyleColor.color(.systemMint)
    var timeZone: TimeZone? = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
    var minimumDate: Date?
    var maximumDate: Date?
    var date: Date?
    var pickerMode:UIDatePicker.Mode? = .dateAndTime
    var titleFont:UIFont?
    var returnDateFormat:DateFormat? = .yyyy_To_ss
    var titleString: String? = "Title"
}
