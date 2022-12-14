//
//  MapMessageView.swift
//  Pharmacy
//
//  Created by CGI-Kite on 27.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import CoreLocation

typealias MapRouteAction = ((MapMessageView.RouteEvent) -> Void)

class MapMessageView: UIView {

    @IBOutlet private weak var swipeView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet weak private var addressLabel: UILabel!
    @IBOutlet weak private var phoneLabel: UILabel!
    @IBOutlet weak private var workTimeLabel: UILabel!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!

    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var medicineCountLabel: UILabel!
    @IBOutlet weak var medicineStackView: UIStackView!
    
    @IBOutlet weak var noMedicineTopSpace: NSLayoutConstraint!
    @IBOutlet weak var nonEmptyMedicineTopSpace: NSLayoutConstraint!
    
    var addToPurchesesHandler: EmptyClosure?
    
    @IBOutlet weak var getDirectionsTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var getDirectionsContainer: UIView!
   
    enum RouteEvent {
        case appleMap, googleMap, uber
    }
    var coordinates: CLLocationCoordinate2D?
    var routeAction: MapRouteAction? {
        get {
            directionsView?.routeAction
        }
        set {
            directionsView?.routeAction = newValue
        }
    }
    private weak var directionsView: MapGetDirections?
    
    private let openedStateConstraintValue: CGFloat = 20.0
    var isDirectionsOpened = false {
        didSet {
            isDirectionsOpened ? showDirections() : hideDirections()
        }
    }

    override func awakeFromNib() {
        swipeView.layer.cornerRadius = swipeView.bounds.height / 2
        setupUI()
    }
    
    private func setupUI() {
        selectButton.layer.cornerRadius = selectButton.bounds.height / 2
        selectButton.setTitle(R.string.localize.farmaciesListAddToBag(), for: .normal)
        let v: MapGetDirections = MapGetDirections.fromNib()
        self.directionsView = v
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = false
        getDirectionsContainer.addSubview(v)
        getDirectionsTopConstraints.constant = MapViewController.GUI.messageHeight
        v.constraintsToSuperView()
        v.closeAction = { [weak self] in
            self?.isDirectionsOpened = false
        }
    }
    
    func setup(pharmacy: PharmacyModel, coordinates: CLLocationCoordinate2D) {
        nameLabel.text = pharmacy.name
        addressLabel.text = pharmacy.geometry.address
        phoneLabel.text = "📞️ " + (pharmacy.phone ?? "phone is unavailible")
        priceLabel.text = "₸\(pharmacy.medicines.first!.price)"
        self.coordinates = coordinates
    }
    
    private func addMedicines(medicines: [PharmacyModel.SimpleMedicine], name: String) {
        
        medicineStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        for medicine in medicines {
            let v: FoundMedicineView = FoundMedicineView.fromNib()
            v.titleLabel.text = "medicine"
            v.priceLabel.text = "₸\(medicine.price)"
            medicineStackView.addArrangedSubview(v)
        }
    }

    func apply(title: String) {
        nameLabel.text = title
        medicineStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
    }
    
    private func showDirections() {
        getDirectionsTopConstraints.constant = openedStateConstraintValue
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    private func hideDirections() {
        getDirectionsTopConstraints.constant = bounds.height
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func openMap(_ sender: UIButton) {
    }
    
    @IBAction func selectFarmacy(_ sender: UIButton) {
        self.addToPurchesesHandler?()
    }

    @IBAction func getDirection(_ sender: Any) {
        isDirectionsOpened.toggle()
    }
}
