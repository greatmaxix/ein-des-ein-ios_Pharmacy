//
//  ChatModel.swift
//  Pharmacy
//
//  Created by Egor Bozko on 03.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree
import MessageKit

enum ChatEvent: Event {
    case close
}

protocol ChatInput: MessagesDataSource, MessagesDisplayDelegate, MessagesLayoutDelegate {
    func load()
}

protocol ChatOutput: class {
    var customMessageSizeCalculator: MessageSizeCalculator { get }
    func didResive(messages: [Message])
}

final class ChatModel: Model, ChatInput {
   
    var output: ChatOutput!
    var messages: [Message] = []
    
    private var sender: SenderType = Sender(senderId: "-2", displayName: "Пользователь")
    
    override init(parent: EventNode?) {
        super.init(parent: parent)
    }
    
    func load() {
        
        switch UserSession.shared.authorizationStatus {
        case .authorized(let userId):
            let s = Sender(senderId: "\(userId)", displayName: UserSession.shared.user?.name ?? "")
            sender = s
            self.messages = [Message(.routeSwitch, sender: s, messageId: "0", date: Date())]
        case .notAuthorized:
            self.messages = Message.unauthorizedMessages()
        }
        
        output.didResive(messages: self.messages)
    }
}

extension ChatModel: MessagesDataSource {
    func currentSender() -> SenderType {
        return sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func customCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell!
        
        switch message.kind {
        case .custom(let kind as Message.CustomMessageKind):
            switch kind {
            case .button:
                cell = messagesCollectionView.dequeueReusableCell(withReuseIdentifier: ChatButtonCollectionViewCell.reuseIdentifier, for: indexPath)
            case .routeSwitch:
                cell = messagesCollectionView.dequeueReusableCell(withReuseIdentifier: ChatRouteCollectionViewCell.reuseIdentifier, for: indexPath)
                (cell as? ChatRouteCollectionViewCell)?.routeAction = { route in
                    switch route {
                    case .doctor: break
                    case .pharmacist: break
                    default: break
                    }
                }
                
            case .product: break
            }
        default: break
        }
        
        return cell
    }
    
    func customCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator {
        return output.customMessageSizeCalculator
    }
}

extension ChatModel: MessagesDisplayDelegate {
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
}

extension ChatModel: MessagesLayoutDelegate {
    
}
