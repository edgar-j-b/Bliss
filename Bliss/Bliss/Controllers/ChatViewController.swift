//
//  ChatViewController.swift
//  Bliss
//
//  Created by Admin on 7/22/24.
//


import UIKit
///MessageKit: A library for building chat interfaces in iOS applications.
import MessageKit
///InputBarAccessoryView: A library for providing an input bar with accessories.
import InputBarAccessoryView

///This file defines the ChatViewController class, which manages the chat interface using the MessageKit library. It handles displaying messages, sending new messages, and configuring the chat view
///This class manages the chat interface, allowing users to view and send messages.
class ChatViewController: MessagesViewController {
    
    //MARK: - Properties
    
    ///message: The message object containing chat details.
    var message : Message?
    ///chats: An array of Chat objects representing the chat history.
    var chats: [Chat] = []
    ///parentVC: The parent view controller, which is typically ChatMainViewController.
    var parentVC: UIViewController?
    ///formatter: A DateFormatter instance used to format the date for messages.
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    //MARK: - Lifecycle Methods
    
    ///Called after the view has been loaded into memory. Sets up delegates for messagesCollectionView and messageInputBar, populates messages, and reloads the chat view.
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        populateMessageType()
        messagesCollectionView.reloadData()
    }
    
    ///Called after the view has been added to the view hierarchy. Makes the view controller the first responder to display the keyboard.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    //MARK: - Methods
    
    ///Populates the chats array with messages from the message object.
    func populateMessageType() {
        if let messages = message?.messages {
            chats = messages
        }
    }
    
    ///Inserts a new message into the chats array and updates the messagesCollectionView.
    func insertMessage(_ message: Chat) {
        chats.append(message)
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([chats.count - 1])
            if chats.count >= 2 {
                messagesCollectionView.reloadSections([chats.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToLastItem(animated: false)
            }
        })
    }
    
    ///Checks if the last section of the messagesCollectionView is visible.
    func isLastSectionVisible() -> Bool {
        
        guard !chats.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: chats.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
}

//MARK: - Extensions

///Provides data for the messages view, including the current sender, number of sections, message data, and text attributes for various labels.
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate {
    
    func currentSender() -> any MessageKit.SenderType {
        return Sender(senderId: String(BaseData.getInstance().getCurrentUser().id ?? 0), displayName: BaseData.getInstance().getCurrentUser().getFullname())
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return chats.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return chats[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(string: "Read", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
}

// MARK: - MessagesDisplayDelegate

///Configures display attributes for messages, such as text color, link detection, message style, and avatar views.
extension ChatViewController: MessagesDisplayDelegate {
    
    // MARK: - Text Messages
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        switch detector {
        case .hashtag, .mention: return [.foregroundColor: UIColor.blue]
        default: return MessageLabel.defaultAttributes
        }
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation, .mention, .hashtag]
    }
    
    // MARK: - All Messages
    
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(tail, .curved)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        
        if let chat = message as? Chat {
            
            let avatar = Avatar(image: chat.profilePicture, initials: "")
            avatarView.set(avatar: avatar)
        }
    }
    
}

///Handles sending messages when the send button is pressed. Inserts new messages into the chat history and updates the view.
extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        if (parentVC as! ChatMainViewController).createNew {
            parentVC?.dismiss(animated: true)
        }
        else {
            let attributedText = messageInputBar.inputTextView.attributedText!
            let range = NSRange(location: 0, length: attributedText.length)
            attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
                
                let substring = attributedText.attributedSubstring(from: range)
                let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
                print("Autocompleted: `", substring, "` with context: ", context ?? [])
            }
            
            let components = inputBar.inputTextView.components
            messageInputBar.inputTextView.text = String()
            messageInputBar.invalidatePlugins()
            
            for component in components {
                if let str = component as? String, !str.isEmpty {
                    let currentUser = Sender(senderId: "99", displayName: BaseData.getInstance().getCurrentUser().getFullname() ?? " ")
                    
                    let chat = Chat(sender: currentUser, messageId: "1", sentDate: Date(), kind: .text(str), profilePicture:  UIImage(named: "ic_current_user")!)
                    insertMessage(chat)
                }
            }
        }
        
    }
    
    
}

