//
//  Message.swift
//  Pharmacy
//
//  Created by Egor Bozko on 03.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import MessageKit

struct Message: MessageType {
    
    enum CustomMessageKind {
        case button, routeSwitch, product(Product)
    }
    
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    private init(kind: MessageKind, sender: Sender, messageId: String, date: Date) {
        self.kind = kind
        self.sender = sender
        self.messageId = messageId
        self.sentDate = date
    }
    
    init(_ text: String, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .text(text), sender: sender, messageId: messageId, date: date)
    }
    
    init(_ image: UIImage, sender: Sender, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(image: image)
        self.init(kind: .photo(mediaItem), sender: sender, messageId: messageId, date: date)
    }

    init(_ imageURL: URL, sender: Sender, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(imageURL: imageURL)
        self.init(kind: .photo(mediaItem), sender: sender, messageId: messageId, date: date)
    }
    
    init(_ product: Product, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .custom(product), sender: sender, messageId: messageId, date: date)
    }
    
    init(_ kind: CustomMessageKind, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .custom(kind), sender: sender, messageId: messageId, date: date)
    }
    
    static func unauthorizedMessages() -> [Message] {
        let sender = Sender(senderId: "-1", displayName: "Фармацевт")
        let user = Sender.guest()
        
        let message1 = Message("Добрый день!", sender: sender, messageId: "1", date: Date())
        let message2 = Message("Чтобы перейти в чат с фармацевтом, Вам необходимо зарегестрироваться или авторизироваться", sender: sender, messageId: "2", date: Date())
        let message3 = Message("Ок! Хорошо!", sender: user, messageId: "3", date: Date())
        let message4 = Message("Как мне это сделать?", sender: user, messageId: "4", date: Date())
        let message5 = Message("Ничего сложного, просто укажите свою контактуню информацию", sender: sender, messageId: "5", date: Date())
        let message6 = Message(.button, sender: sender, messageId: "5", date: Date())
        return [message1, message2, message3, message4, message5, message6]
    }
}