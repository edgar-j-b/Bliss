//
//  String+Extensions.swift
//  Bliss
//
//  Created by Admin on 7/22/24.
//


import Foundation

///This file defines an extension for the String class, adding a method to convert a string to a Date using a specified date format.
///Extends the String class to add new functionality.
extension String {
    ///Converts the string to a Date object using the specified date format
    ///format: A String representing the date format to use for conversion. The default format is "yyyy-MM-dd HH:mm:ss".
    ///An optional Date object. If the string cannot be converted to a Date using the specified format, it returns nil.
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        return date
        
    }
}
