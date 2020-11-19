//
//  CustomMessageSizeCalculator.swift
//  Pharmacy
//
//  Created by Egor Bozko on 03.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import MessageKit

class CustomMessageSizeCalculator: MessageSizeCalculator {
    override func messageContainerSize(for message: MessageType) -> CGSize {
        guard let collection = layout?.collectionView else { return .zero }
        switch message.kind {
        case .custom(let kind):
            let width = collection.frame.width - (collection.adjustedContentInset.left + collection.adjustedContentInset.right)
            if let k = kind as? Message.CustomMessageKind {
                switch k {
                case .button: return CGSize(width: width, height: 200.0)
                case .routeSwitch: return CGSize(width: width, height: 400.0)
                case .product: return CGSize(width: width, height: 224.0)
                case .chatClosing: return CGSize(width: width, height: 64.0)
                case .application: return CGSize(width: width, height: 152.0)
                case .recipe: return CGSize(width: width, height: 90.0)
                }
            }
        default: return .zero
        }
        return .zero
    }
}
