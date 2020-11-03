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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        model.load()
    }
    
    func setupCollection() {
        
        messagesCollectionView.messagesDataSource = model
        messagesCollectionView.messagesDisplayDelegate = model
        messagesCollectionView.messagesLayoutDelegate = model
        messagesCollectionView.register(ChatButtonCollectionViewCell.nib, forCellWithReuseIdentifier: ChatButtonCollectionViewCell.reuseIdentifier)
        messagesCollectionView.register(ChatRouteCollectionViewCell.nib, forCellWithReuseIdentifier: ChatRouteCollectionViewCell.reuseIdentifier)
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            sizeCalculator = CustomMessageSizeCalculator(layout: layout)
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
        }
    }
    
}

extension ChatViewController: ChatOutput {
    var customMessageSizeCalculator: MessageSizeCalculator {
        return sizeCalculator
    }
    
    func didResive(messages: [Message]) {
        messagesCollectionView.reloadData()
    }
}
