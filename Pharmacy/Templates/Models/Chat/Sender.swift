//
//  Sender.swift
//  Pharmacy
//
//  Created by Egor Bozko on 03.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import MessageKit

struct Sender: SenderType {
    var senderId: String
    var displayName: String
    
    static func guest() -> Sender {
        return Sender(senderId: "-2", displayName: "Гость")
    }
}
