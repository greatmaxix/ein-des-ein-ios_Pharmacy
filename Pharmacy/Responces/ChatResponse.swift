//
//  ChatResponse.swift
//  Pharmacy
//
//  Created by Egor Bozko on 04.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import UIKit

struct ChatResponse: Codable, Equatable {
    var items: [Chat]
}

struct CreateMessagesResponse: Codable, Equatable {
    var item: ChatMessage
}
