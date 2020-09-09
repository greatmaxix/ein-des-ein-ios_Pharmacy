//
//  WishlistModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 20.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import EventsTree

protocol WishlistInput: class {
    func close()
}

protocol WishlistOutput: class {
    func didLoadList()
    func load()
}

final class WishlistModel: EventNode {
    
    let medicineDataSource = TableDataSource<MedicineCellSection>()
    let provider = DataManager<WishListAPI, WishlistResponse>()
    unowned var output: WishlistOutput!
}

extension WishlistModel: WishlistInput {
    
    func load() {

        
        output.didLoadList()
    }
    
    func close() {
        raise(event: ProfileEvent.close)
    }
}
