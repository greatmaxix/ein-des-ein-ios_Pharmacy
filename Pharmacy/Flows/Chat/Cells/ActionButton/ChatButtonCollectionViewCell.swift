//
//  ChatButtonCollectionViewCell.swift
//  Pharmacy
//
//  Created by Egor Bozko on 03.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import MessageKit

class ChatButtonCollectionViewCell: UICollectionViewCell {
    
    var buttonAction: (() -> Void)?
    
    @IBOutlet weak var button: RoundedButton!
    
    @IBAction func actionPressed(_ sender: Any) {
        buttonAction?()
    }
    
}
