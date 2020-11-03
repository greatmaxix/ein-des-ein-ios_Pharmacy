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

protocol ChatInput: class {
    
}

protocol ChatOutput: class {
    
}

final class ChatModel: Model, ChatInput {

    struct Sender: SenderType {
        var senderId: String
        var displayName: String
    }
    
    var output: ChatOutput!
    var messages: [MessageType] = []
    
    override init(parent: EventNode?) {
        super.init(parent: parent)
    }
}

extension ChatModel: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(senderId: "0", displayName: "Sender")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}
