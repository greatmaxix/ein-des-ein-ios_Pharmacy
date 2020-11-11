//
//  ChatViewController.swift
//  Pharmacy
//
//  Created by Egor Bozko on 03.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import MessageKit
import Photos

class ChatViewController: MessagesViewController, NavigationBarStyled {
    
    var style: NavigationBarStyle = .normalWithoutSearch
    var model: ChatInput!
    var sizeCalculator: MessageSizeCalculator!
    var chatBar: ChatInputBar? {
        return messageInputBar as? ChatInputBar
    }
    
    var photoLibraryAuthorizationStatus: PHAuthorizationStatus!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        messageInputBar = ChatInputBar()
        sizeCalculator = CustomMessageSizeCalculator()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setRightBarButtonItems([UIBarButtonItem.init(image: R.image.info(), style: .plain, target: self, action: #selector(showChatInfo))], animated: true)
        model.load()
    }
    
    func setup() {
        photoLibraryAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
    }
    
    func showDeniedMessage() {
        showMessage(text: "Отройте доступ к фото в найстройках приложения")
    }
    
    func requestPhotoLibraryAuthorization() {
        PHPhotoLibrary.requestAuthorization {[weak self] status in
            self?.photoLibraryAuthorizationStatus = status
            switch status {
            case .authorized, .limited:
                self?.openGallery()
            case .denied:
                self?.showDeniedMessage()
            default: break
            }
        }
    }
    
    @objc func showChatInfo() {
        
    }
}
    
extension ChatViewController: ChatOutput {
    func openGallery() {
        switch photoLibraryAuthorizationStatus {
        case .authorized, .limited:
            chatBar?.showGallery()
        case .notDetermined, .none:
            requestPhotoLibraryAuthorization()
        case .denied, .restricted:
            showDeniedMessage()
        default: break
        }
    }
    
    func closeGallery() {
        chatBar?.hideGallery()
    }
}
