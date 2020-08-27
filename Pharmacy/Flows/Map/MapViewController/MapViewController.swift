//
//  MapViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 25.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import GoogleMaps

protocol MapOutput: class {
    func locationUpdated(newCoordinate: CLLocationCoordinate2D)
}

class MapViewController: UIViewController {
    
    private struct GUI {
        static let messageHeight: CGFloat = 375
    }
    
    @IBOutlet private weak var messageView: UIView!
    @IBOutlet weak var messageHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var mapView: GMSMapView!
    @IBOutlet private weak var currentLocationButton: UIButton!
    @IBOutlet private weak var zoomInButton: UIButton!
    @IBOutlet private weak var zoomOutButton: UIButton!

    var model: MapInput!
    
    private var userMarker: GMSMarker?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupMap()
    }
    
    private func setupUI() {
        currentLocationButton.layer.cornerRadius = currentLocationButton.bounds.width / 2
        zoomInButton.layer.cornerRadius = zoomInButton.bounds.width / 2
        zoomOutButton.layer.cornerRadius = zoomOutButton.bounds.width / 2
        zoomInButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        zoomOutButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        let v: MapMessageView = MapMessageView.fromNib()
        v.translatesAutoresizingMaskIntoConstraints = false
        messageView.addSubview(v)
        v.constraintsToSuperView()
        
        messageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        messageView.layer.cornerRadius = 18
    }
    
    private func setupMap() {
        mapView.camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 10.0)
        model.startLocationTracking()
        mapView.delegate = self
    }
    
    @IBAction private func moveToCurrentLocation(_ sender: UIButton) {
        if let marker = userMarker {
            mapView.moveCamera(GMSCameraUpdate.setTarget(marker.position))
        } else {
            model.startLocationTracking()
        }
    }
    
    @IBAction private func zoomIn(_ sender: UIButton) {
        mapView.animate(toZoom: mapView.camera.zoom + 1)
    }
    
    @IBAction private func zoomOut(_ sender: Any) {
        mapView.animate(toZoom: mapView.camera.zoom - 1)
    }
    
    private func showMessage() {
        messageHeightConstraint.constant = GUI.messageHeight
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideMessage() {
        messageHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        showMessage()
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        hideMessage()
    }
}

extension MapViewController: MapOutput {
    
    func locationUpdated(newCoordinate: CLLocationCoordinate2D) {
        mapView.moveCamera(GMSCameraUpdate.setTarget(newCoordinate))
        
        mapView.clear()
        let marker = GMSMarker(position: newCoordinate)
        marker.iconView = UINib(resource: R.nib.userMarkerView).instantiate(withOwner: nil, options: nil)[0] as? UIView
        marker.map = mapView
        userMarker = marker
    }
}
