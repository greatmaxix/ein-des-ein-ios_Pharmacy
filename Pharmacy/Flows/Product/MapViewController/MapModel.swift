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
    func openFarmacyList()
    func load()
    func farmacyAt(index: Int) -> PharmacyModel?
    func addToCart(productId: Int)
    func open(_ route: MapMessageView.RouteEvent, coordinate: CLLocationCoordinate2D)
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
    
    var currentLocation: CLLocation? {
        locationService.currentLocation
    }
    
    func startLocationTracking() {
        locationService.updateCurrentLocation()
    }
    
    func openFarmacyList() {
        raise(event: ProductModelEvent.openFarmacyList(pharmacies))
    }
    
    func open(_ route: MapMessageView.RouteEvent, coordinate: CLLocationCoordinate2D) {
        raise(event: ProductModelEvent.route(route, coordinate: coordinate))
    }
    
    func load() {
        guard let medicineId = medicineId else { return }
        provider.load(target: .getPharmacies(medicineId: medicineId,
            regionId: UserDefaultsAccessor.regionId,
            page: Const.startPage,
            pageCount: Const.itemsPerPage),
            completion: { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.pharmacies = response.pharmacies
                let positions: [CLLocationCoordinate2D] = self.pharmacies.map({
                    CLLocationCoordinate2D(latitude: $0.geometry.lat, longitude: $0.geometry.lng)
                })
                let prices: [Double] = self.pharmacies.compactMap({$0.medicines.first?.price})
                self.output.setMarkers(positions: positions, prices: prices)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
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
}

// MARK: - LocationServiceDelegate

extension MapModel: LocationServiceDelegate {
    
    func locationUpdated(currentLocation: CLLocationCoordinate2D) {
        output.locationUpdated(newCoordinate: currentLocation)
    }
}

private extension MapModel {
    struct Const {
        static let startPage: Int = 1
        static let itemsPerPage: Int = 10
    }
}
