//
//  BaseData.swift
//  Bliss
//
//  Created by Admin on 7/20/24.
//

import Foundation
import MessageKit

///BaseData is a singleton class responsible for managing and providing access to application-wide data, including user information and messages. It handles the current user, user preferences, and message management.
class BaseData {
    fileprivate static var sSharedInstance: BaseData!
    
    ///Provides a singleton instance of the BaseData class. If an instance does not already exist, it creates one. This method ensures that only one instance of BaseData is used throughout the application.
    static func getInstance() -> BaseData {
        
        if sSharedInstance == nil {
            sSharedInstance = BaseData()
        }
        
        return sSharedInstance
    }
    
    ///Private initializer to prevent creating multiple instances of BaseData. The class uses the singleton pattern to ensure only one instance.
    private init(){}
    
    ///An instance of User representing the currently logged-in user. It is initialized with predefined values in this class.
    var currentUser = User(id: 99, firstName: "Edgar", lastName: "Balangue", profilePicture: "ic_current_user", likes: nil, age: 33, occupation: "Mobile App Developer",gender: "Male", userPreference: "Female", birthday: "June 12, 1990")
    
    ///An array of User objects representing a list of other users. This array is initialized with sample users for demonstration purposes.
    var peoples: [User] = [
        User(id: 1, firstName: "Chelsea", lastName: "Brags", profilePicture: "sample_user_1", likes: nil, age: 23, occupation: "Graphic Designer", gender: "Female"),
        User(id: 2, firstName: "Josie", lastName: "Brags", profilePicture: "sample_user_2", likes: nil, age: 22, occupation: "Model/Photographer", gender: "Female")]
    
    ///Returns the currently logged-in user (currentUser).
    func getCurrentUser() -> User {
        return currentUser
    }
    
    ///Returns a filtered list of users whose gender matches the current user's preference. This list is based on the peoples array and the current user's userPreference.
    func getForYouPeople() -> [User] {
        
        var forYouList: [User] = []
        peoples.forEach { user in
            if (user.gender?.lowercased() == getCurrentUser().userPreference?.lowercased()) {
                forYouList.append(user)
            }
        }
        
        return forYouList
    }
    
    ///Checks if there is already a message with the specified user. Searches through populated messages and returns the message if found. Otherwise, it returns nil.
    func checkIfAlreadyGotMessage(user: User) -> Message? {
        
        var messageFind: Message? = nil
        populateMessages().forEach { message in
            if message.recipients![0].id == user.id {
                messageFind = message
            }
        }
        
        return messageFind
    }
    
    ///Creates and returns an array of Message objects with sample chat data. Each Message object contains multiple Chat objects representing individual messages between users. This method initializes sample data for testing or demonstration purposes.
    func populateMessages() -> [Message] {
        var messages : [Message] = []
        
        let user1 = Sender(senderId: "1", displayName: "Chelsea Brags")
        let currentUser = Sender(senderId: "99", displayName: getCurrentUser().getFullname() ?? " ")
        
        var chat1 = Chat(sender: currentUser, messageId: "1", sentDate: Date(), kind: MessageKind.text("hi"),profilePicture: UIImage(named: "ic_current_user")!)
        var chat2 = Chat(sender: user1, messageId: "2", sentDate: Date(), kind: MessageKind.text("hello"),profilePicture: UIImage(named: "sample_user_1")!)
        var chat3 = Chat(sender: currentUser, messageId: "3", sentDate: Date(), kind: MessageKind.text("how are you"),profilePicture: UIImage(named: "ic_current_user")!)
        var chat4 = Chat(sender: user1, messageId: "4", sentDate: Date(), kind: MessageKind.text("im fine"),profilePicture: UIImage(named: "sample_user_1")!)
        
        let message1 = Message(id: 1, messages: [chat1,chat2,chat3,chat4], recipients: [User(id: 1, firstName: "Chelsea", lastName: "Brags", profilePicture: "sample_user_1", likes: nil, age: 23, occupation: "Graphic Designer", gender: "Female")], lastChat: "im fine")
        
        messages.append(message1)
        
        return messages
    }
}
