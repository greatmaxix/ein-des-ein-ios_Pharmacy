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
}

final class MapModel: EventNode {
    
    weak var output: MapOutput!
    private var locationService = LocationService()
    private var medicineId: Int?
    private var pharmacies: [PharmacyModel] = []
    private let provider = DataManager<MapAPI, PharmacyResponse>()
    
    init(parent: EventNode?, medicineId: Int) {
        super.init(parent: parent)
        
        self.medicineId = medicineId
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
        raise(event: ProductModelEvent.openFarmacyList(pharmacies))
    }
    
    func load() {
        guard let medicineId = medicineId else { return }
        
        provider.load(target: .getPharmacies(medicineId: medicineId, regionId: 21/*UserDefaultsAccessor.regionId*/, page: 1, pageCount: 10), completion: { [weak self] result in
            
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
    
    func farmacyAt(index: Int) -> PharmacyModel? {
        return pharmacies[index]
    }
}
