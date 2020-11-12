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
    func didSelect(action: ImageSelectionAction)
}

final class ChatInputBar: InputBarAccessoryView {
    
    var attachInputItem: AttachInputItem!
    
    struct GUI {
        static let cornerRadius: CGFloat = 10.0
        static let maskedCorners: CACornerMask = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        static let backgroundColor = UIColor.white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
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
        
        attachInputItem = AttachInputItem(view: self) {[weak self] _ in
            (self?.delegate as? ChatInputBarDelegate)?.attach()
        }
        
        setStackViewItems([attachInputItem], forStack: .left, animated: false)
        attachInputItem.setSize(CGSize(width: 26.0, height: 38.0), animated: false)
        setRightStackViewWidthConstant(to: 75.0, animated: false)
        setStackViewItems([sendButton, InputBarButtonItem.fixedSpace(2.0)], forStack: .right, animated: false)
        
        sendButton.setSize(CGSize(width: 30.0, height: 38.0), animated: false)
        sendButton.image = R.image.send()
        sendButton.title = nil
        sendButton.alpha = 0.0
        
        sendButton.onTextViewDidChange {[weak self] (button, inputView) in
            let isTextEmpty = inputView.text.isEmpty
            UIView.animate(withDuration: 0.2) {
                button.alpha = isTextEmpty  ? 0.0 : 1.0
                inputView.layer.borderColor = (isTextEmpty ? R.color.mediumGrey() : R.color.welcomeBlue())?.cgColor
            }
            self?.hideGallery()
        }
        sendButton.backgroundColor = .clear
        middleContentViewPadding.right = -62.0
        
        decorationBlackShadow()
    }
    
    func showGallery() {
        DispatchQueue.main.async { [weak self] in
            self?.attachInputItem.isHighlighted = true
            let width = self?.bottomStackView.frame.width ?? 0.0
            let itemWidth = width / 3.0
            let rect = CGRect(origin: .zero, size: CGSize(width: width, height: itemWidth * 2))
            let galleryItem = ChatGallery(frame: rect)
            
            galleryItem.didSelectImageHandler = {[weak self] action in
                (self?.delegate as? ChatInputBarDelegate)?.didSelect(action: action)
            }
            self?.setStackViewItems([galleryItem], forStack: .bottom, animated: false)
        }
    }
    
    func hideGallery() {
        if bottomStackViewItems.count > 0 {
            DispatchQueue.main.async { [weak self] in
                self?.attachInputItem.isHighlighted = false
                self?.setStackViewItems([], forStack: .bottom, animated: true)
            }
        }
    }
}
