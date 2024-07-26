//
//  TinderCardModel.swift
//  Bliss
//
//  Created by Admin on 7/20/24.
//

import UIKit
///This file defines the TinderCardModel struct, which is used to represent a model for a Tinder-like card in the app. It contains information about a user including their name, age, occupation, image, and an optional User object.
struct TinderCardModel {
    ///name: The name of the user represented by the card.
    let name: String
    ///age: The age of the user.
    let age: Int
    ///occupation: The occupation of the user, which is optional.
    let occupation: String?
    ///image: An optional UIImage representing the user’s profile picture or card image.
    let image: UIImage?
    ///user: An optional User object that might contain additional information about the user. (Note: The User type is not defined in this file, so it should be defined elsewhere in the codebase.)
    let user: User?
}

