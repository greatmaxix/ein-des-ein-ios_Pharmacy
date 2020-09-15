//
//  LocationService.swift
//  Waldo
//
//  Created by Yaroslav Bykov on 27.03.2020.
//  Copyright © 2020 Yaroslav Bykov. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

enum LocationError: Error {
    case restricted
    case denied
    case other
}

protocol LocationServiceDelegate: class {
    func locationUpdated(currentLocation: CLLocationCoordinate2D)
}

final class LocationService: NSObject {
    
// MARK: - Properties
    private let manager = CLLocationManager()

    weak var locationDelegate: LocationServiceDelegate?
    var locationResult: Result<CLLocationCoordinate2D, Error>?
    let defaultLocation = CLLocationCoordinate2D(latitude: 33.755708, longitude: -84.38836)
    
    var currentLocation: CLLocation? {
        
        return manager.location
    }
    
    // MARK: - Initialize
    
    override init() {
        super.init()
        manager.delegate = self
        
        manager.desiredAccuracy = 10
        if let coordinate = manager.location?.coordinate {
            locationResult = .success(coordinate)
        }
        
        setup()
        updateCurrentLocation()
    }
    
    @discardableResult
    func updateCurrentLocation() -> Result<CLLocationCoordinate2D, Error>? {
        guard CLLocationManager.locationServicesEnabled() else {
            return .failure(LocationError.restricted)
        }
        
        defer {
            manager.startUpdatingLocation()
            if let location = manager.location {
                locationResult = .success(location.coordinate)
            }
        }
        
        return locationResult
    }
    
// MARK: - Support Methods
    
    private func setup() {
        let status = CLLocationManager.authorizationStatus()
        if status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled() {
            return
        }
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
            return
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            locationResult = .failure(LocationError.restricted)
        case .denied:
            locationResult = .failure(LocationError.denied)
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        @unknown default:
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else { return }
        locationResult = .success(location.coordinate)
        
        locationDelegate?.locationUpdated(currentLocation: location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        switch CLLocationManager.authorizationStatus() {
        case .restricted:
            locationResult = .failure(LocationError.restricted)
        case .denied:
            locationResult = .failure(LocationError.denied)
        default:
            locationResult = .failure(LocationError.other)
        }
    }
}
