//
//  FeedComment.swift
//  Bliss
//
//  Created by Admin on 7/20/24.
//

import Foundation

///The FeedComment struct represents a comment on a feed item. It conforms to the Decodable protocol, allowing it to be initialized from JSON data.
struct FeedComment: Decodable {
    
    ///An optional integer representing the unique identifier for the comment.
    let id: Int32?
    ///An optional string containing the text of the comment.
    let comment:String?
    ///An optional User object representing the user who made the comment.
    let user: User?
}
