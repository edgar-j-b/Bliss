//
//  User.swift
//  Bliss
//
//  Created by Admin on 7/20/24.
//

import Foundation

///The User struct represents a user profile in an application. It conforms to the Decodable and Equatable protocols, allowing it to be initialized from JSON and compared for equality.
struct User: Decodable,Equatable {
    
    ///An optional integer representing the unique identifier for the user.
    let id: Int32?
    ///An optional string containing the user's first name.
    let firstName: String?
    ///An optional string containing the user's last name.
    let lastName: String?
    ///An optional string representing the URL or path to the user's profile picture.
    let profilePicture: String?
    ///An optional array of User objects representing users who have liked this user.
    var likes: [User]?
    ///An optional integer representing the user's age.
    let age: Int?
    ///An optional string describing the user's occupation.
    let occupation: String?
    ///An optional string indicating the user's gender.
    let gender: String?
    ///An optional string describing the user's preferences. Default is nil.
    var userPreference: String? = nil
    /// An optional string representing the user's birthday. Default is nil.
    var birthday: String? = nil
    
    ///Returns the full name of the user by concatenating the firstName and lastName properties. If either property is nil, it defaults to an empty space.
    func getFullname() -> String {
        return (firstName ?? " ") + " " + (lastName ?? " ")
        
    }
}

