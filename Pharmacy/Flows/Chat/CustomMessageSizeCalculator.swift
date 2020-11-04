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
        switch message.kind {
        case .custom(let kind):
            if let k = kind as? Message.CustomMessageKind {
                switch k {
                case .button: return CGSize(width: layout?.collectionView?.frame.width ?? 0.0, height: 200.0)
                case .routeSwitch: return CGSize(width: layout?.collectionView?.frame.width ?? 0.0, height: 400.0)
                case .product: return CGSize(width: layout?.collectionView?.frame.width ?? 0.0, height: 192.0)
                }
            }
        default: return .zero
        }
        return .zero
    }
}
