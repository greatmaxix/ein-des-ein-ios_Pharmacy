//
//  ChatService.swift
//  Pharmacy
//
//  Created by Egor Bozko on 04.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import IKEventSource

protocol ChatServiceDelegate: class {
    func didRecive(message: Message)
}

final class ChatService {
    
    enum ChatStatus: String, Codable, Equatable {
        case opened, answered, requestForClosing, closed
    }
    weak var delegate: ChatServiceDelegate?
    let chat: Chat
    
    private let eventSource: EventSource
    
    init(_ chat: Chat, delegate: ChatServiceDelegate?) {
        self.chat = chat
        let uuid = UserSession.shared.user
        let url = URL(string: "https://mercure.pharmacies.fmc-dev.com/.well-known/mercure?topic=\(chat.topicName)")!
        self.delegate = delegate
        
        eventSource = EventSource(url: url)
        
        eventSource.onOpen {
            print("Open connection")
        }
        
        eventSource.onComplete { (code, isComlete, error) in
            print("Сomplete - \(code ?? 0), \(isComlete ?? false), \(error?.localizedDescription ?? "")")
        }
        
        eventSource.addEventListener("message") {[weak self] (code, response, error) in
            
            print("Message - \(String(describing: code)) \(String(describing: response)) \(error)")
        }
        
        eventSource.connect()
    }
}
