//
//  FarmacySelectionModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 25.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import EventsTree

enum FarmacySelectionEvent: Event {
    case openMap
    case openFarmacyList
}

protocol MapHolderDelegate: class {
    var title: String { get }
    func openMap()
    func openFarmacyList()
}

final class MapHolderModel: EventNode {
    
}

extension MapHolderModel: MapHolderDelegate {
    
    var title: String {
        R.string.localize.farmaciesListTitle()
    }
    
    func openMap() {
        raise(event: FarmacySelectionEvent.openMap)
    }
    
    func openFarmacyList() {
        raise(event: FarmacySelectionEvent.openFarmacyList)
    }
}
