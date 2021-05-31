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
import Moya

protocol MapInput: class {
    
    var currentLocation: CLLocation? { get }
    
    func startLocationTracking()
    func farmacyAt(index: Int) -> PharmacyModel?
    func addToCart(productId: Int)
    func open(_ route: MapMessageView.RouteEvent, coordinate: CLLocationCoordinate2D)
    func set(pharmacies: [PharmacyModel])
    func setMarkerPositionsAndPrices()
}

final class MapModel: EventNode {
    
    weak var output: MapOutput!
    private var locationService = LocationService()
    private var medicineId: Int?
    private var pharmacies: [PharmacyModel] = []
    private let provider = DataManager<MapAPI, PharmacyResponse>()
    private let cartAddingProvider = DataManager<ProductCartAPI, PostResponse>()
    
    init(parent: EventNode?, medicineId: Int) {
        super.init(parent: parent)
        
        self.medicineId = medicineId
        locationService.locationDelegate = self
    }
}

// MARK: - MapInput

extension MapModel: MapInput {
    func set(pharmacies: [PharmacyModel]) {
        self.pharmacies = pharmacies
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
    
    func addToCart(productId: Int) {
        cartAddingProvider.load(target: .addPharmacyToCart(productId: productId)) {[weak self] result in
            guard self != nil else { return }
            
            switch result {
            case .success:
                print("reciept \(productId) was successfully added to chart")
                self?.output.successfullyAddedToCart()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func farmacyAt(index: Int) -> PharmacyModel? {
        return pharmacies[index]
    }
    
    func setMarkerPositionsAndPrices() {
        let positions: [CLLocationCoordinate2D] = self.pharmacies.map({
            CLLocationCoordinate2D(latitude: $0.geometry.lat, longitude: $0.geometry.lng)
        })
        let prices: [Double] = self.pharmacies.compactMap({$0.medicines.first?.price})
        self.output?.setMarkers(positions: positions, prices: prices)
    }
}

// MARK: - LocationServiceDelegate

extension MapModel: LocationServiceDelegate {
    
    func locationUpdated(currentLocation: CLLocationCoordinate2D) {
        output.locationUpdated(newCoordinate: currentLocation)
    }
}
