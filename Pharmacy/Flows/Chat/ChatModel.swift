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
import IKEventSource
import InputBarAccessoryView

enum ChatEvent: Event {
    case close
}

protocol ChatInput: MessagesDataSource, MessagesDisplayDelegate, MessagesLayoutDelegate {
    func load()
}

protocol ChatOutput: MessagesViewController {
    var customMessageSizeCalculator: MessageSizeCalculator { get }
}

final class ChatModel: Model, ChatInput {
   
    var output: ChatOutput! {
        didSet {
            output.messageInputBar.delegate = self
//            output.subscribeToKeyboard {[weak self] keyboardEvent in
//                switch keyboardEvent {
//                case .willShow: self?.output.messagesCollectionView.scrollToBottom(animated: false)
//                default: break
//                }
//            }
        }
    }
    private var messages: [Message] = []
    private var chatProvider = DataManager<ChatAPI, ChatListResponse>()
    private var messagesListProvider = DataManager<ChatAPI, MessageListResponse>()
    private var createMessageProvider = DataManager<ChatAPI, CreateMessageResponse>()
    private var chatService: ChatService?
    private var sender: ChatSender = ChatSender.guest()
    
    override init(parent: EventNode?) {
        super.init(parent: parent)
    }
    
    func load() {
        switch UserSession.shared.authorizationStatus {
        case .authorized:
            chatProvider.load(target: .chatList) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.didReciveChat(list: response.items)
                case .failure(let error):
                    print(error)
                }
            }
        case .notAuthorized:
            self.messages = []
            Message.unauthorizedMessages().forEach {self.insertMessage($0)}
        }
    }
    
//    Load chat messages if opened or answered chat exist
    
    private func didReciveChat(list: [Chat]) {
        if let openedChat = list.first(where: {$0.status == .opened || $0.status == .answered}) {
            messagesListProvider.load(target: .messageList((openedChat.id))) {[weak self] result in
                switch result {
                case .success(let response):
                    response.items.forEach {
                        self?.didRecive(message: $0)
                    }
                    self?.output.messagesCollectionView.scrollToBottom()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            self.sender = ChatSender.currentUser()
            self.chatService = ChatService(openedChat, delegate: self)
        } else {
            self.messages = [Message(.routeSwitch, sender: sender, messageId: "0", date: Date())]
            self.output.messagesCollectionView.reloadData()
        }
    }
    
    private func didSelect(route: ChatAPI.ChatRoute) {
        chatProvider.load(target: .create(route)) {[weak self] result in
            switch result {
            case .success(let result):
                self?.didReciveChat(list: result.items)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func authorize() {
        raise(event: OnboardingEvent.close)
    }
    
    // MARK: - Helpers
    
    func insertMessage(_ message: Message) {
        messages.append(message)
        
        // Reload last section to update header/footer labels and insert a new one
        
        output.messagesCollectionView.performBatchUpdates({
            output.messagesCollectionView.insertSections([messages.count - 1])
            if messages.count >= 2 {
                output.messagesCollectionView.reloadSections([messages.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.output.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        
        guard !messages.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        
        return output.messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
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
                (cell as? ChatButtonCollectionViewCell)?.buttonAction = { [weak self] in
                    self?.authorize()
                }
            case .routeSwitch:
                cell = messagesCollectionView.dequeueReusableCell(withReuseIdentifier: ChatRouteCollectionViewCell.reuseIdentifier, for: indexPath)
                (cell as? ChatRouteCollectionViewCell)?.routeAction = {[weak self] route in
                    
                    self?.didSelect(route: route)
                }
            case .chatClosing:
                cell = messagesCollectionView.dequeueReusableCell(withReuseIdentifier: ChatCloseCollectionViewCell.reuseIdentifier, for: indexPath)
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

extension ChatModel: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard let chatId = chatService?.chat.id else { return }
        createMessageProvider.load(target: .createMessage(chatId, text)) { result in
            switch result {
            case .success:
                print("Message sent")
            case .failure(let error):
                print("Message error - \(error.localizedDescription)")
            }
        }
    }
}

extension ChatModel: ChatServiceDelegate {
    func didRecive(message: ChatMessage) {
        if message.isSenderCurrentUser {
            let m = Message(message.text, sender: self.sender, messageId: "\(message.id)", date: message.createdAt.date() ?? Date())
            self.insertMessage(m)
        } else {
            let s = ChatSender(senderId: "\(message.ownerUuid)", displayName: message.ownerType)
            let m = Message(message.text, sender: s, messageId: "\(message.id)", date: message.createdAt.date() ?? Date())
            self.insertMessage(m)
        }
    }
}
