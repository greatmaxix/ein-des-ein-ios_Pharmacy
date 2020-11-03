//
//  ChatModel.swift
//  Pharmacy
//
//  Created by Egor Bozko on 03.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

enum ChatEvent: Event {
    case close
}

protocol ChatInput: class {
    
}

protocol ChatOutput: class {
    
}

final class ChatModel: Model, ChatInput {
    
    var output: ChatOutput!
    
    override init(parent: EventNode?) {
        super.init(parent: parent)
    }
}
