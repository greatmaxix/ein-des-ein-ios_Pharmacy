//
//  CommonMapModel.swift
//  Pharmacy
//
//  Created by Egor Bozko on 28.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree
import CoreLocation

protocol CommonMapInput: class {
    var currentLocation: CLLocation? { get }
    func startLocationTracking()
    func stopLocationTracking()
}

final class CommonMapModel: EventNode, CommonMapInput {
    
    weak var output: MapOutput!
    private var locationService = LocationService()
    
    var currentLocation: CLLocation? {
        locationService.currentLocation
    }
    
    override init(parent: EventNode?) {
        super.init(parent: parent)
        locationService.locationDelegate = self
    }
    
    func startLocationTracking() {
        locationService.updateCurrentLocation()
    }
    
    func stopLocationTracking() {
        
    }
}

extension CommonMapModel: LocationServiceDelegate {
    func locationUpdated(currentLocation: CLLocationCoordinate2D) {
        output.locationUpdated(newCoordinate: currentLocation)
    }
}
