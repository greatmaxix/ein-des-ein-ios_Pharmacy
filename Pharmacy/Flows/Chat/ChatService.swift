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
    func didRecive(data: ChatMessagesResponse)
}

final class ChatService {
    
    enum ChatStatus: String, Codable, Equatable {
        case opened, answered, closeRequest = "close_request", closed
    }
    
    enum ChatEvent: String {
        case message, changeStatus = "change_status", none = ""
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
        decoder.dataDecodingStrategy = .deferredToData
        decoder.keyDecodingStrategy = .convertFromSnakeCase
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
    }
    
    func onMessage(eventType: String, messageEvent: MessageEvent) {
        print("Message - \(messageEvent.data)")
        
        do {
            let message = try decoder.decode(ChatMessagesResponse.self, from: Data(messageEvent.data.utf8))
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didRecive(data: message)
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
