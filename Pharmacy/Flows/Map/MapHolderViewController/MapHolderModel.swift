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

protocol MapHolderDelegate {
    func openMap()
    func openFarmacyList()
}

final class MapHolderModel: EventNode {
    
}

extension MapHolderModel: MapHolderDelegate {
    func openMap() {
        raise(event: FarmacySelectionEvent.openMap)
    }
    
    func openFarmacyList() {
        raise(event: FarmacySelectionEvent.openFarmacyList)
    }
}
