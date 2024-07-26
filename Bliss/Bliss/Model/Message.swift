//
//  Message.swift
//  Bliss
//
//  Created by Admin on 7/22/24.
//

import Foundation

///The Message struct represents a message or chat thread, including details about the chat messages, recipients, and the last chat timestamp. It does not conform to Decodable, meaning it is not directly initialized from JSON.
struct Message {
    
    /// An optional integer representing the unique identifier for the message or chat thread.
    let id: Int32?
    ///An optional array of Chat objects representing the individual chat messages within the thread.
    let messages: [Chat]?
    ///An optional array of User objects representing the users who are recipients of the message or chat thread.
    let recipients: [User]?
    ///An optional string representing the timestamp of the last chat message or activity within the thread.
    let lastChat: String?
}
