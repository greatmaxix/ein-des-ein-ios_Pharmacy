//
//  ChatViewController.swift
//  Pharmacy
//
//  Created by Egor Bozko on 03.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import MessageKit

class ChatViewController: MessagesViewController, NavigationBarStyled {
    
    var style: NavigationBarStyle = .normalWithoutSearch
    var model: ChatInput!
    var sizeCalculator: MessageSizeCalculator!
    var chatBar: ChatInputBar? {
        return messageInputBar as? ChatInputBar
    }
    init() {
        super.init(nibName: nil, bundle: nil)
        messageInputBar = ChatInputBar()
        sizeCalculator = CustomMessageSizeCalculator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setRightBarButtonItems([UIBarButtonItem.init(image: R.image.info(), style: .plain, target: self, action: #selector(showChatInfo))], animated: true)
    
        model.load()
    }
    
    @objc func showChatInfo() {
        
    }
}
    
extension ChatViewController: ChatOutput {
    func openGallery() {
        chatBar?.showGallery()
    }
    
    func closeGallery() {
        chatBar?.hideGallery()
    }
}
