//
//  ChatCloseCollectionViewCell.swift
//  Pharmacy
//
//  Created by Egor Bozko on 04.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class ChatCloseCollectionViewCell: UICollectionViewCell {
    
    enum ChatCloseEvent {
        case continueChat, close
    }
    
    var actionHandler: ((ChatCloseEvent) -> Void)?
    
    @IBAction func continueChat(_ sender: Any) {
        actionHandler?(.continueChat)
    }
    
    @IBAction func endChat(_ sender: Any) {
        actionHandler?(.close)
    }
}
