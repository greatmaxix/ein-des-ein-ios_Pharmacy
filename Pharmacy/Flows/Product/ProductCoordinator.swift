//
//  ProductCoordinator.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 13.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree
import CoreLocation
import MapKit

struct ProductFlowConfiguration {
    let parent: EventNode
    let navigation: UINavigationController
}

final class ProductCoordinator: EventNode, Coordinator {
    let navigation: UINavigationController
    
    func createFlow() -> UIViewController {
        fatalError()
    }
    
    func createFlowFor(product: Medicine) -> ProductViewController {
        let root =  R.storyboard.product.instantiateInitialViewController()!
        let model = ProductModel(product: product, parent: self)
        root.model = model
        model.output = root
        return root
    }
    
    func createFlowFor(product: ChatProduct) -> ProductViewController {
        let root =  R.storyboard.product.instantiateInitialViewController()!
        let model = ProductModel(product: product, parent: self)
        root.model = model
        model.output = root
        return root
    }
    
    init(configuration: ProductFlowConfiguration) {
        navigation = configuration.navigation
        super.init(parent: configuration.parent)
        addHandler(.onRaise) { [weak self] (event: ProductModelEvent) in
            
            guard let self = self else { return }
            
            switch event {
            case .openAnalogsFor(let product), .openCatalogsFor(let product):
                self.openMedicineList(product: product)
            case .openMap(let product):
                // TODO: Replace product by medicine after adding detail medicine request
                self.createMapFlow(medicineId: product.identifier)
            case .openFarmacyList(let pharmacies):
                self.openMapFarmacyList(pharmacies: pharmacies)
            case .openCheckout:
                self.openCheckout()
            case .route(let route, let coordinate):
                self.open(route, coordinate: coordinate)
            case .openChat:
                self.openChat()
            }
        }
    }
}

fileprivate extension ProductCoordinator {
    
    func openMedicineList(product: Product) {
        let viewController = R.storyboard.catalogue.medicineListViewController()!
        let model = MedicineListModel(product: product, parent: self)
        viewController.model = model
        model.output = viewController
        navigation.pushViewController(viewController, animated: true)
    }
    
    func createMapFlow(medicineId: Int) {
        guard let vc = R.storyboard.product.pharmacyMapListContainerViewController() else { return }
        let model = PharmacyMapListContainerModel(parent: self, medicineId: medicineId)
        model.output = vc
        vc.model = model
        vc.hidesBottomBarWhenPushed = true
        navigation.pushViewController(vc, animated: true)
    }
    
    func openChat() {
        let vc = ChatCoordinator(parent: self, navigation: navigation).createFlow()
        navigation.pushViewController(vc, animated: true)
    }
    
    func openMapFarmacyList(pharmacies: [PharmacyModel]) {
        guard let vc = R.storyboard.product.mapFarmacyListViewController() else { return }
        let model = MapFarmacyListModel(parent: self, pharmacies: pharmacies)
        model.output = vc
        vc.model = model
        navigation.pushViewController(vc, animated: true)
    }
    
    func openCheckout() {
        guard let vc = R.storyboard.product.checkoutViewController() else { return }
        let model = CheckoutModel(parent: self)
        vc.model = model
        model.output = vc
        navigation.pushViewController(vc, animated: true)
    }
    
    func open(_ route: MapMessageView.RouteEvent, coordinate: CLLocationCoordinate2D) {
        switch route {
        case .appleMap:
            let distance: CLLocationDistance = 1000
            let regionSpan = MKCoordinateRegion(center: coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
            let placemakr = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placemakr)
            
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            mapItem.openInMaps(launchOptions: options)
        case .googleMap:
            let request = "comgooglemaps://?saddr=&daddr=\(coordinate.latitude),\(coordinate.longitude)&directionsmode=driving"
            let url = URL(string: request)!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        case .uber:
            let model = InDevelopmentModel(title: R.string.localize.empty_model_title.localized(), subTitle: R.string.localize.empty_subtitle_title.localized(), image: "inDelivary")
            raise(event: AppEvent.presentInDev(model))
        }
    }
}
