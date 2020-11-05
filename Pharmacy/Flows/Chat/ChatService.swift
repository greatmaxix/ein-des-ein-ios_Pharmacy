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
    func didRecive(message: ChatMessage)
}

final class ChatService {
    
    enum ChatStatus: String, Codable, Equatable {
        case opened, answered, requestForClosing, closed
    }
    
    enum EventName: String {
        case message, none = ""
    }
    
    weak var delegate: ChatServiceDelegate?
    let chat: Chat
    private let decoder = JSONDecoder.init()
    private let eventSource: EventSource
    
    init(_ chat: Chat, delegate: ChatServiceDelegate?) {
        self.chat = chat
        let url = URL(string: "https://mercure.pharmacies.fmc-dev.com/.well-known/mercure?topic=\(chat.topicName)")!
        self.delegate = delegate
        
        eventSource = EventSource(url: url)
        
        eventSource.onOpen {
            print("Open connection")
        }
        
        eventSource.onComplete {(code, isComlete, error) in
            print("Сomplete - \(code ?? 0), \(isComlete ?? false), \(error?.localizedDescription ?? "")")
        }
        
        eventSource.onMessage {[weak self] (_, eventName, response) in
            let event = EventName(rawValue: eventName ?? "") ?? EventName.none
            
            if let r = response {
                do {
                    switch event {
                    case .message:
                        if let messageResponse = try self?.decoder.decode(ChatMessagesResponse.self, from: Data(r.utf8)) {
                            self?.delegate?.didRecive(message: messageResponse.body.item)
                        }
                    case .none: print("Unknow chat event")
                    }
                } catch {
                    print("DecodeErorr")
                }
            }
            
        }
        
        eventSource.connect()
    }
}
