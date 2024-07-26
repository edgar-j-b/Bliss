//
//  Chat.swift
//  Bliss
//
//  Created by Admin on 7/22/24.
//

import Foundation
import MessageKit

///The Chat struct conforms to the MessageType protocol from the MessageKit library. It represents an individual chat message, including details about the sender, message content, and related metadata.
struct Chat: MessageType {
    
    ///The sender of the chat message. It conforms to the SenderType protocol from MessageKit, representing the person or entity that sent the message.
    var sender: any MessageKit.SenderType
    ///A unique identifier for the chat message. This is used to distinguish between different messages within a chat thread.
    var messageId: String
    ///The date and time when the chat message was sent.
    var sentDate: Date
    /// The type of the chat message content, as defined by MessageKit. This could represent text, image, video, or other message types supported by MessageKit.
    var kind: MessageKit.MessageKind
    /// A UIImage representing the profile picture of the sender. This is used to display the sender's profile image in the chat interface.
    var profilePicture: UIImage
    
}
