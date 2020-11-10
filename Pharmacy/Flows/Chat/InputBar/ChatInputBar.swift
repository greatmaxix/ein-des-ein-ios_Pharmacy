//
//  ChatInputBar.swift
//  Pharmacy
//
//  Created by Egor Bozko on 06.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import InputBarAccessoryView

protocol ChatInputBarDelegate: InputBarAccessoryViewDelegate {
    func attach()
}

class ChatInputBar: InputBarAccessoryView {
        
    struct GUI {
        static let cornerRadius: CGFloat = 10.0
        static let maskedCorners: CACornerMask = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        static let backgroundColor = UIColor.white
    }
        
    private var galleryItem: ChatGallery!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        
        galleryItem = ChatGallery()
        
        setStackViewItems([galleryItem], forStack: .bottom, animated: false)
        galleryItem.isHidden = true
        separatorLine.height = 8.0
        backgroundColor = .clear
        
        separatorLine.backgroundColor = .clear
        
        inputTextView.backgroundColor = R.color.lightGray()
        inputTextView.layer.cornerRadius = 17
        inputTextView.layer.borderWidth = 1.0
        inputTextView.layer.borderColor = R.color.mediumGrey()?.cgColor
        
        backgroundView.layer.cornerRadius = GUI.cornerRadius
        backgroundView.layer.maskedCorners = GUI.maskedCorners
        backgroundView.backgroundColor = GUI.backgroundColor
        backgroundView.layer.masksToBounds = true
        
        middleContentViewPadding = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 12.0, right: 0.0)
        
        var textInset = inputTextView.textContainerInset
        textInset.left = 12.0
        textInset.right = 30.0
        inputTextView.textContainerInset = textInset
        inputTextView.placeholderLabel.text = " Что Вас волнует?"
        inputTextView.placeholderLabel.textColor = R.color.gray()
        
        setLeftStackViewWidthConstant(to: 60.0, animated: false)
        
        let v = AttachInputItem(view: self) {[weak self] _ in
            (self?.delegate as? ChatInputBarDelegate)?.attach()
        }
        
        setStackViewItems([v], forStack: .left, animated: false)
        v.setSize(CGSize(width: 30.0, height: 38.0), animated: false)
        setRightStackViewWidthConstant(to: 75.0, animated: false)
        setStackViewItems([sendButton, InputBarButtonItem.fixedSpace(2.0)], forStack: .right, animated: false)
        
        sendButton.setSize(CGSize(width: 30.0, height: 38.0), animated: false)
        sendButton.image = R.image.send()
        sendButton.title = nil
        sendButton.alpha = 0.0
        sendButton.onTextViewDidChange { (button, inputView) in
            let isTextEmpty = inputView.text.isEmpty
            UIView.animate(withDuration: 0.2) {
                button.alpha = isTextEmpty  ? 0.0 : 1.0
                inputView.layer.borderColor = (isTextEmpty ? R.color.mediumGrey() : R.color.welcomeBlue())?.cgColor
            }
        }
        sendButton.backgroundColor = .clear
        middleContentViewPadding.right = -62.0
        
        decorationBlackShadow()
    }
    
    func showGallery() {
        let itemWidth = frame.width / 3.0
        galleryItem.frame = CGRect(origin: .zero, size: CGSize(width: frame.width, height: itemWidth * 2))
        galleryItem.isHidden = false
        setStackViewItems([galleryItem], forStack: .bottom, animated: true)
        galleryItem.setSize(CGSize(width: frame.width, height: (frame.width / 3) * 2  ), animated: true)
    }
    
    func hideGallery() {
        galleryItem.isHidden = true
    }
}
