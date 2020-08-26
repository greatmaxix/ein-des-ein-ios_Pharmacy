//
//  MapViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 25.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
//import GoogleMaps

class MapViewController: UIViewController {
    
    @IBOutlet private weak var mapView: UIView!
    @IBOutlet private weak var currentLocationButton: UIButton!
    @IBOutlet private weak var zoomInButton: UIButton!
    @IBOutlet private weak var zoomOutButton: UIButton!

    var model: MapInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        currentLocationButton.layer.cornerRadius = currentLocationButton.bounds.width / 2
        zoomInButton.layer.cornerRadius = zoomInButton.bounds.width / 2
        zoomOutButton.layer.cornerRadius = zoomOutButton.bounds.width / 2
        zoomInButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        zoomOutButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    @IBAction private func moveToCurrentLocation(_ sender: UIButton) {
    }
    
    @IBAction private func zoomIn(_ sender: UIButton) {
    }
    
    @IBAction private func zoomOut(_ sender: Any) {
    }
    
}

extension MapViewController: MapOutput {}
