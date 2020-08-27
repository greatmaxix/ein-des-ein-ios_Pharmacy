//
//  MapModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 25.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree
import CoreLocation

enum MapEvent: Event {
    case openFarmacyList
}

protocol MapInput: class {
    
    var currentLocation: CLLocation? { get }
    
    func startLocationTracking()
    func openFarmacyList()
}

final class MapModel: EventNode {
    
    weak var output: MapOutput!
    private var locationService = LocationService()
    
    override init(parent: EventNode?) {
        super.init(parent: parent)
        
        locationService.firstLocationUpdate = { [weak self] currentLocation in
            self?.output.locationUpdated(newCoordinate: currentLocation)
        }
    }
}

extension MapModel: MapInput {
    
    var currentLocation: CLLocation? {
        locationService.currentLocation
    }
    
    func startLocationTracking() {
        locationService.updateCurrentLocation()
    }
    
    func openFarmacyList() {
        raise(event: MapEvent.openFarmacyList)
    }
}
