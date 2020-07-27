//
//  WelcomeModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 27.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

enum WelcomeEvent: Event {
    
    case openMap
    case openBarCodeReader
}

protocol WelcomeModelOutput: class {}
protocol WelcomeModelInput: class {}

final class WelcomeModel: EventNode {
    
    unowned var output: WelcomeModelOutput!
}

extension WelcomeModel: WelcomeModelInput {
    
}
