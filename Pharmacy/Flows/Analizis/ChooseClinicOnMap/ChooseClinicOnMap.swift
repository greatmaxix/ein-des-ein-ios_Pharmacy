//
//  ChooseClinicOnMap.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 10.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation

import UIKit
import GoogleMaps
import MBProgressHUD

protocol ChooseClinicOnMapMapOutput: class {
    func locationUpdated(newCoordinate: CLLocationCoordinate2D)
    func setMarkers(positions: [CLLocationCoordinate2D], prices: [Double])
    func successfullyAddedToCart()
}

class ChooseClinicOnMap: UIViewController {
    
    private struct GUI {
        static let messageHeight: CGFloat = 375
    }

    @IBOutlet private weak var messageViewHolder: UIView!
    @IBOutlet private weak var messageHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var mapView: GMSMapView!
    @IBOutlet private weak var currentLocationButton: UIButton!
    @IBOutlet private weak var zoomInButton: UIButton!
    @IBOutlet private weak var zoomOutButton: UIButton!
    @IBOutlet private weak var selectionBackground: UIView?

    @IBOutlet private weak var orderButton: UIButton!
    @IBOutlet private weak var clinicDetailButton: UIButton!
    @IBOutlet private weak var mapButton: UIButton!
    
    var model: ChooseClinicOnMapViewModelInput!
    
    private lazy var activityIndicator: MBProgressHUD = {
        setupActivityIndicator()
    }()
    
    private var userMarker: GMSMarker?
    private var messageView: MapMessageView!
    private var swipeGesture: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupMap()
        setupLocalization()
        model.load()
    }
    
    private func setupUI() {
        currentLocationButton.layer.cornerRadius = currentLocationButton.bounds.width / 2
        zoomInButton.layer.cornerRadius = zoomInButton.bounds.width / 2
        zoomOutButton.layer.cornerRadius = zoomOutButton.bounds.width / 2
        zoomInButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        zoomOutButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        let v: MapMessageView = MapMessageView.fromNib()
        v.translatesAutoresizingMaskIntoConstraints = false
        messageViewHolder.addSubview(v)
        v.constraintsToSuperView()
        messageView = v
        
        v.routeAction = {[weak self] route in
            guard let c = self?.messageView.coordinates else { return }
            v.isDirectionsOpened = false
            self?.model.open(route, coordinate: c)
        }
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(hideMessage))
        swipeGesture.direction = .down
        v.addGestureRecognizer(swipeGesture)
        
        messageViewHolder.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        messageViewHolder.layer.cornerRadius = 18
        
        selectionBackground?.dropBlueShadow()
        selectionBackground?.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        selectionBackground?.layer.cornerRadius = 8
    }
    
    private func setupMap() {
        model.startLocationTracking()
        mapView.delegate = self
    }
    
    //TO-DO: Fix Model
    @IBAction func orderAction(_ sender: Any) {
        model.orderService(model: .init(clinicName: "", adressClinic: "", imageClinic: "", priceClinic: "", phoneNumber: "", ordered: false))
    }
    
    //TO-DO: Fix Model
    @IBAction func mapAction(_ sender: Any) {
//        model.showOnMap(model: .init(clinicName: "", adressClinic: "", imageClinic: "", priceClinic: "", phoneNumber: "", ordered: false))
    }
    
    //TO-DO: Fix Model
    @IBAction func clinicInfoAction(_ sender: Any) {
        model.openDeteilClinic(.init(clinicName: "", adressClinic: "", imageClinic: "", priceClinic: "", phoneNumber: "", ordered: false))
    }
    
    @IBAction private func moveToCurrentLocation(_ sender: UIButton) {
        if let marker = userMarker {
            marker.map = mapView
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
    
    private func moveMap(toCoordinate: CLLocationCoordinate2D, zoom: Float?) {
        mapView.animate(to: GMSCameraPosition(latitude: toCoordinate.latitude,
            longitude: toCoordinate.longitude, zoom: zoom ?? mapView.camera.zoom))
    }
    
    private func showMessage(pharmacy: PharmacyModel, coordinates: CLLocationCoordinate2D) {
        messageHeightConstraint.constant = GUI.messageHeight
        
        messageView.setup(pharmacy: pharmacy, coordinates: coordinates)
        messageView.addToPurchesesHandler = {[weak self] in
            self?.activityIndicator.show(animated: true)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func hideMessage() {
        messageHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    private func setupLocalization() {
        title = "Выбор клиники"
    }
}

// MARK: - GMSMapViewDelegate

extension ChooseClinicOnMap: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        hideMessage()
    }
}

// MARK: - MapOutput

extension ChooseClinicOnMap: MapOutput {
    func successfullyAddedToCart() {
        showMessage(text: "Товар успешно добавлен в корзину!")
        activityIndicator.hide(animated: true)
    }
    
    func setMarkers(positions: [CLLocationCoordinate2D], prices: [Double]) {
        mapView.clear()
        
        if positions.count > 1 {
            let path = GMSMutablePath()
            positions.forEach({ path.add($0) })
            let bounds = GMSCoordinateBounds(path: path)
            mapView.animate(with: GMSCameraUpdate.fit(bounds))
        } else if let coordinate = positions.first {
            moveMap(toCoordinate: coordinate, zoom: Const.startZoom)
        }
        
        for i in 0..<positions.count {
            
            let marker = GMSMarker()
            let pinView: FarmacyPinView? = R.nib.farmacyPinView(owner: nil)
            pinView?.tag = i
            marker.position = positions[i]
            pinView?.price = prices[i]
            marker.iconView = pinView
            marker.map = mapView
        }
    }
    
    func locationUpdated(newCoordinate: CLLocationCoordinate2D) {
        
        if userMarker == nil {
            let marker = GMSMarker(position: newCoordinate)
            marker.iconView = R.nib.userMarkerView(owner: nil)
            marker.map = mapView
            userMarker = marker
        } else {
            userMarker?.position = newCoordinate
            userMarker?.map = mapView
        }
    }
}

private extension ChooseClinicOnMap {
    
    struct Const {
        static let startZoom: Float = 10
    }
}
