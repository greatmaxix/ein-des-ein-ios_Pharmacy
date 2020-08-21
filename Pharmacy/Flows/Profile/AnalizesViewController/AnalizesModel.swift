//
//  AnalizesModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 21.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import EventsTree

protocol AnalizesInput {
    func close()
}

final class AnalizesModel: EventNode {
    
}

extension AnalizesModel: AnalizesInput {
    
    func close() {
        raise(event: ProfileEvent.close)
    }
}
