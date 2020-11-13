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

import InputBarAccessoryView

enum ChatEvent: Event {
    case close
}

protocol ChatInput: MessagesDataSource, MessagesDisplayDelegate, MessagesLayoutDelegate {
    func load()
    func sendMessage(text: String)
    func upload(images: [LibraryImage])
}

protocol ChatOutput: MessagesViewController {
    func openGallery()
    func closeGallery()
    func openLibrary()
    func openCamera()
    func uploadFinished(image: LibraryImage, with result: UploadImageResult)
}

final class ChatModel: Model, ChatInput {
    weak var output: ChatOutput? {
        didSet {
            setupCollection()
        }
    }
    
    private let chatProvider = DataManager<ChatAPI, ChatListResponse>()
    private let createChatProvider = DataManager<ChatAPI, CreateChatResponse>()
    private let messagesListProvider = DataManager<ChatAPI, MessageListResponse>()
    private let createMessageProvider = DataManager<ChatAPI, CreateMessageResponse>()
    private let uploadProvider = DataManager<ChatAPI, CustomerImageUploadResponse>()
    private let sendImageProvider = DataManager<ChatAPI, CreateMessageResponse>()
    private let sendProductProvider = DataManager<ChatAPI, CreateProductMessageResponse>()
    
    private var chatService: ChatService?
    private var sender: ChatSender = ChatSender.guest()
    private var sizeCalculator: CustomMessageSizeCalculator!
    
    private var messages: [Message] = []
    
    deinit {
        chatService?.stop()
        print("Chat model deinit")
    }
    
    override init(parent: EventNode?) {
        super.init(parent: parent)
    }
    
    func load() {
        switch UserSession.shared.authorizationStatus {
        case .authorized:
            output?.showActivityIndicator()
            chatProvider.load(target: .chatList) { [weak self] result in
                self?.output?.hideActivityIndicator()
                switch result {
                case .success(let response):
                    self?.didReciveChat(list: response.items)
                case .failure(let error):
                    print(error)
                }
            }
        case .notAuthorized:
            self.messages = Message.unauthorizedMessages()
            self.output?.messagesCollectionView.reloadData()
            self.output?.messageInputBar.isHidden = true
        }
    }
    
    func sendMessage(text: String) {
        guard let chatId = chatService?.chat.id, text.isEmpty == false else { return }
        createMessageProvider.load(target: .createMessage(chatId, text)) { response in
            print(response)
        }
    }
    
    func setupCollection() {
        if let layout = output?.messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            sizeCalculator = CustomMessageSizeCalculator(layout: layout)
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
        }
        
        output?.scrollsToBottomOnKeyboardBeginsEditing = true
        output?.showMessageTimestampOnSwipeLeft = true
        
        guard let collection = output?.messagesCollectionView else { return }
        
        collection.backgroundColor = R.color.lightGray()
        collection.messagesDataSource = self
        collection.messagesDisplayDelegate = self
        collection.messagesLayoutDelegate = self
        
        collection.register(ChatButtonCollectionViewCell.nib, forCellWithReuseIdentifier: ChatButtonCollectionViewCell.reuseIdentifier)
        collection.register(ChatRouteCollectionViewCell.nib, forCellWithReuseIdentifier: ChatRouteCollectionViewCell.reuseIdentifier)
        collection.register(ChatCloseCollectionViewCell.nib, forCellWithReuseIdentifier: ChatCloseCollectionViewCell.reuseIdentifier)
        collection.register(ChatProductCollectionViewCell.nib, forCellWithReuseIdentifier: ChatProductCollectionViewCell.reuseIdentifier)
        collection.register(ChatApplicationCollectionViewCell.nib, forCellWithReuseIdentifier: ChatApplicationCollectionViewCell.reuseIdentifier)
    }
    
    func proccessChat(items: [ChatMessage]) {
        items.forEach {
            self.insertMessage($0.message)
        }
        output?.messagesCollectionView.scrollToBottom(animated: true)
        output?.messageInputBar.isHidden = false
        output?.messageInputBar.becomeFirstResponder()
    }
    
    func upload(images: [LibraryImage]) {
        output?.showActivityIndicator()
        recursiveUpload(images: images)
    }

    private func recursiveUpload(images: [LibraryImage]) {
        if let image = images.first, let data = image.original.jpegData(compressionQuality: 0.5) {
            let mime = "image/\(image.url.lastPathComponent.components(separatedBy: ".").last ?? "jpg")"
            uploadProvider.load(target: .upload(data: data, mime: mime, name: image.url.lastPathComponent)) {[weak self] result in
                self?.output?.uploadFinished(image: image, with: result)
                switch result {
                case .success(let response):
                    self?.sendUploadedImageWith(response: response)
                default: break
                }
                var i = images
                i.removeFirst()
                self?.recursiveUpload(images: i)
            }
        } else {
            output?.hideActivityIndicator()
        }
    }
    
    private func sendUploadedImageWith(response: CustomerImageUploadResponse) {
        guard let chatId = chatService?.chat.id else { return }
        sendImageProvider.load(target: .sendImage(chatId: chatId, uuid: response.item.uuid)) { result in
            switch result {
            case .success(let r):
                print("Image uploaded with -\(r)")
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
//    Load chat messages if opened or answered chat exist
    
    private func didReciveChat(list: [Chat]) {
        if let openedChat = list.first(where: {$0.status == .opened || $0.status == .answered}) {
            output?.title = openedChat.type
            output?.showActivityIndicator()
            messagesListProvider.load(target: .messageList((openedChat.id))) {[weak self] result in
                self?.output?.hideActivityIndicator()
                switch result {
                case .success(let response):
                    self?.proccessChat(items: response.items)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            self.sender = ChatSender.currentUser()
            self.chatService = ChatService(openedChat, topicName: UserSession.shared.user?.topicName, delegate: self)
        } else {
            self.messages = [Message(.routeSwitch, sender: sender, messageId: "0", date: Date())]
            self.output?.messagesCollectionView.reloadData()
        }
    }
    
    private func didSelect(route: ChatAPI.ChatRoute) {
        output?.showActivityIndicator()
        createChatProvider.load(target: .create(route)) {[weak self] result in
            self?.output?.hideActivityIndicator()
            self?.messages = []
            self?.output?.messagesCollectionView.reloadData()
            self?.output?.messageInputBar.isHidden = false
            self?.output?.becomeFirstResponder()
            switch result {
            case .success(let result):
                self?.didReciveChat(list: [result.item])
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func authorize() {
        raise(event: OnboardingEvent.close)
    }
    
// MARK: - Attachment
    
    func openPhotoGalery() {
        output?.openGallery()
    }
    
    func openPhotoLibrary() {
        output?.openLibrary()
    }
    
    func openCamera() {
        output?.openCamera()
    }
    
    // MARK: - Helpers
    
    func hideKeyboard() {
        if output?.messageInputBar.inputTextView.isFirstResponder ?? false {
            output?.navigationController?.view.endEditing(true)
        }
    }
    
    func insertMessage(_ message: Message) {
        messages.append(message)
        
        // Reload last section to update header/footer labels and insert a new one
        
        output?.messagesCollectionView.performBatchUpdates({
            output?.messagesCollectionView.insertSections([messages.count - 1])
            if messages.count >= 2 {
                output?.messagesCollectionView.reloadSections([messages.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.output?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        
        guard !messages.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        
        return output?.messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath) ?? false
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
                (cell as? ChatButtonCollectionViewCell)?.buttonAction = {[weak self] in self?.authorize()}
            case .routeSwitch:
                cell = messagesCollectionView.dequeueReusableCell(withReuseIdentifier: ChatRouteCollectionViewCell.reuseIdentifier, for: indexPath)
                (cell as? ChatRouteCollectionViewCell)?.routeAction = {[weak self] route in self?.didSelect(route: route)}
            case .chatClosing:
                cell = messagesCollectionView.dequeueReusableCell(withReuseIdentifier: ChatCloseCollectionViewCell.reuseIdentifier, for: indexPath)
            case .product(let product):
                cell = messagesCollectionView.dequeueReusableCell(withReuseIdentifier: ChatProductCollectionViewCell.reuseIdentifier, for: indexPath)
                (cell as? ChatProductCollectionViewCell)?.apply(product: product, actionHandler: { _ in
                    
                })
            case .application(let application):
                cell = messagesCollectionView.dequeueReusableCell(withReuseIdentifier: ChatApplicationCollectionViewCell.reuseIdentifier, for: indexPath)
                (cell as? ChatApplicationCollectionViewCell)?.apply(attachment: application, isFromCurrentSender: message.sender.senderId == sender.senderId)
            }
        default: break
        }
        
        return cell
    }
    
    func customCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator {
        return sizeCalculator
    }
}

extension ChatModel: MessagesDisplayDelegate {
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return MessageStyle.bubbleTail(isFromCurrentSender(message: message) ? MessageStyle.TailCorner.bottomRight : MessageStyle.TailCorner.bottomLeft, MessageStyle.TailStyle.pointedEdge)
    }
}

extension ChatModel: MessagesLayoutDelegate {
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 10.0
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? R.color.welcomeBlue()! : R.color.mediumGrey()!
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor.white : R.color.textDarkBlue()!
    }
}

extension ChatModel: ChatServiceDelegate {
    func didRecive(data: ChatMessagesResponse) {
        if let m = data.body?.item.message {
            insertMessage(m)
        }
    }
}
