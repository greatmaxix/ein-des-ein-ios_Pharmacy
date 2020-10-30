//
//  FarmacyListModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 25.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import EventsTree

protocol FarmacyListInput: class {
    var dataSourse: TableDataSource<MapFarmacyCellSection> {get}
    func addToCart(productId: Int)
    func load()
}

protocol FarmacyListOutput: class {
    
}

class MapFarmacyListModel: EventNode {

    let medicineDataSourse = TableDataSource<MapFarmacyCellSection>()
    private var pharmacies: [PharmacyModel] = []
    
    private let cartAddingProvider = DataManager<ProductCartAPI, PostResponse>()
    
    init(parent: EventNode?, pharmacies: [PharmacyModel]) {
        super.init(parent: parent)
        
        self.pharmacies = pharmacies
    }
    
    unowned var output: FarmacyListOutput!
}

extension MapFarmacyListModel: FarmacyListInput {
    
    var dataSourse: TableDataSource<MapFarmacyCellSection> {
        medicineDataSourse
    }
    
    func load() {
        medicineDataSourse.cells = pharmacies.map({[weak self] in
            let product = $0
            var cell = MapFarmacyCellSection.init(common: $0)
            cell.addToChartHandler = {
                self?.addToCart(productId: product.medicines.first!.pharmacyProductId)
            }
            return cell
        })
    }
    
    func addToCart(productId: Int) {
        cartAddingProvider.load(target: .addPharmacyToCart(productId: productId)) {[weak self] result in
            guard self != nil else { return }
            
            switch result {
            case .success:
                print("reciept \(productId) was successfully added to chart")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
