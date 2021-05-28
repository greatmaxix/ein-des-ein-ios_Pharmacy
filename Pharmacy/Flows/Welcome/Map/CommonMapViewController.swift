//
//  MapViewController.swift
//  Pharmacy
//
//  Created by Egor Bozko on 28.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import GoogleMaps

class CommonMapViewController: UIViewController, NavigationBarStyled {
    
    var style: NavigationBarStyle = .normalWithoutSearch
    
    @IBOutlet weak var mapView: GMSMapView!
    
    private var userMarker: GMSMarker?
    
    var model: CommonMapInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupTitle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    private func setupMap() {
        model.startLocationTracking()
        mapView.delegate = self
    }
    
    private func setupTitle() {
        if let bar = self.navigationController?.navigationBar as? NavigationBar {
            bar.smallNavBarTitleLabel.text = R.string.localize.farmaciesListTitle.localized()
        }
    }
    
}
extension CommonMapViewController: MapOutput {
    func loadingError() {
        
    }
    
    
    func successfullyAddedToCart() {}
    
    func setMarkers(positions: [CLLocationCoordinate2D], prices: [Double]) {}
    
    func locationUpdated(newCoordinate: CLLocationCoordinate2D) {
        
        if userMarker == nil {
            let marker = GMSMarker(position: newCoordinate)
            marker.iconView = R.nib.userMarkerView(owner: nil)
            marker.map = mapView
            userMarker = marker
            marker.map = mapView
            mapView.moveCamera(GMSCameraUpdate.setTarget(marker.position))
        } else {
            userMarker?.position = newCoordinate
            userMarker?.map = mapView
        }
    }
}

extension CommonMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false
    }
}
