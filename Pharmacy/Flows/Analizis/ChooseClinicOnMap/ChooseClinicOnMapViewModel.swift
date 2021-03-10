//
//  ChooseClinicOnMapViewModel.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 10.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation
import EventsTree
import CoreLocation
import Moya

protocol ChooseClinicOnMapViewModelInput: class {
    
    var currentLocation: CLLocation? { get }
    
    func startLocationTracking()
    func load()
    func open(_ route: MapMessageView.RouteEvent, coordinate: CLLocationCoordinate2D)
}

final class ChooseClinicOnMapViewModel: EventNode {
    
    weak var output: MapOutput!
    
    private var locationService = LocationService()
    private var model: ClinicModel?
    private var pharmacies: [PharmacyModel] = []
    private let provider = DataManager<MapAPI, PharmacyResponse>()
    private let cartAddingProvider = DataManager<ProductCartAPI, PostResponse>()
    
    init(parent: EventNode?, model: ClinicModel) {
        super.init(parent: parent)
        
        self.model = model
        locationService.locationDelegate = self
    }
}

// MARK: - MapInput

extension ChooseClinicOnMapViewModel: ChooseClinicOnMapViewModelInput {
    
    func load() {
        
    }
    
    var currentLocation: CLLocation? {
        locationService.currentLocation
    }
    
    func startLocationTracking() {
        locationService.updateCurrentLocation()
    }
    
    func open(_ route: MapMessageView.RouteEvent, coordinate: CLLocationCoordinate2D) {
        raise(event: ProductModelEvent.route(route, coordinate: coordinate))
    }
}

// MARK: - LocationServiceDelegate

extension ChooseClinicOnMapViewModel: LocationServiceDelegate {
    
    func locationUpdated(currentLocation: CLLocationCoordinate2D) {
        output.locationUpdated(newCoordinate: currentLocation)
    }
}
