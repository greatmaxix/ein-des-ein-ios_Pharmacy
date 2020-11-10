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
    
    override func setup() {
        separatorLine.height = 8.0
        super.setup()
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
        inputTextView.textContainerInset = textInset
        inputTextView.placeholderLabel.text = " Что Вас волнует?"
        inputTextView.placeholderLabel.textColor = R.color.gray()
        
        setLeftStackViewWidthConstant(to: 60.0, animated: false)
        leftStackView.alignment = .center
        
        let v = AttachInputItem(view: self) {[weak self] _ in
            (self?.delegate as? ChatInputBarDelegate)?.attach()
        }
        
        leftStackView.addSubview(v)
        
        decorationBlackShadow()
    }
}
