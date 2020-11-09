//
//  ChatService.swift
//  Pharmacy
//
//  Created by Egor Bozko on 04.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import LDSwiftEventSource

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
    private var eventSource: EventSource!
    private var lastEvent: String?
    private var isNeedReconnect = true
    private var config: EventSource.Config!
    deinit {
        print("Chat service deinit")
    }
    
    init(_ chat: Chat, topicName: String?, delegate: ChatServiceDelegate?) {
        self.chat = chat
        self.delegate = delegate
        if let t = topicName {
            subscribeFor(topicName: t)
        } else {
            subscribeFor(topicName: chat.topicName)
        }
    }
    
    private func subscribeFor(topicName: String) {
        let url = URL(string: "https://mercure.pharmacies.fmc-dev.com/.well-known/mercure?topic=\(topicName)")!
        config = EventSource.Config(handler: self, url: url)
        eventSource = EventSource(config: config)
        eventSource.start()
    }
    
    func stop() {
        isNeedReconnect = false
        eventSource.stop()
        eventSource = nil
        config = nil
    }
}
extension ChatService: EventHandler {
    func onOpened() {
        print("Open connection")
    }
    
    func onClosed() {
        print("Close connection")
        if isNeedReconnect {
            eventSource.start()
            print("Reconnecting...")
        }
    }
    
    func onMessage(eventType: String, messageEvent: MessageEvent) {
        print("Message - \(messageEvent.data)")
        let event = EventName(rawValue: eventType) ?? EventName.none
        do {
            switch event {
            case .message:
                let messageResponse = try decoder.decode(ChatMessagesResponse.self, from: Data(messageEvent.data.utf8))
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didRecive(message: messageResponse.body.item)
                }
            case .none:
                print("Unknow chat event")
            }
        } catch {
            print("DecodeErorr")
        }
    }
    
    func onComment(comment: String) {
        print("Comment - \(comment)")
    }
    
    func onError(error: Error) {
        print("Error \(error.localizedDescription)")
    }
}