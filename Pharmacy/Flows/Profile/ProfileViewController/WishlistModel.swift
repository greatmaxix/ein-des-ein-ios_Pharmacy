//
//  WishlistModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 20.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import EventsTree

protocol WishlistInput {
    func close()
}

final class WishlistModel: EventNode {
    
}

extension WishlistModel: WishlistInput {
    func close() {
        raise(event: ProfileEvent.close)
    }
}
