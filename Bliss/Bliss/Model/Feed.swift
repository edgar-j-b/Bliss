//
//  Feed.swift
//  Bliss
//
//  Created by Admin on 7/20/24.
//

import Foundation

///The Feed struct represents a data model used to describe a feed item, typically used in a social media or content-sharing application. It conforms to the Decodable protocol, allowing it to be initialized from a JSON object.
struct Feed: Decodable {
    
    ///An optional integer representing the unique identifier for the feed item.
    let id: Int32?
    ///An optional User object representing the user who created the feed item.
    let user: User?
    ///An optional string containing the URL of the photo associated with the feed item.
    let photoUrl: String?
    ///An optional string representing the date and time when the feed item was created. The format is typically a date-time string.
    let created: String?
    ///An optional string describing the activity or status related to the feed item. This may represent a type of activity such as "liked", "shared", etc.
    let activty: String?
    ///An optional array of User objects representing the users who liked the feed item.
    var likes: [User]?
    ///An optional array of FeedComment objects representing the comments associated with the feed item.
    var comments: [FeedComment]?
    ///An optional boolean indicating whether the current user has liked the feed item.
    var isLike: Bool?
}
