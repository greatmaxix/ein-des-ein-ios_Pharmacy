//
//  PharmacyMapListContainerModel.swift
//  Pharmacy
//
//  Created by Daniiar Erkinov on 31/5/21.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation
import EventsTree
import CoreLocation

enum PharmacySegment: Int, CaseIterable {
    case list
    case map
}

protocol PharmacyMapListContainerInput: AnyObject {
    func changeSegment(to index: Int)
    func getMedicineId() -> Int
    func getEventNodeParent() -> EventNode?
    func getPharmacies() -> [PharmacyModel]
    func load()
}

final class PharmacyMapListContainerModel: EventNode {
    weak var output: PharmacyMapListContainerOutput?
    
    private let medicineId: Int
    private var eventNodeParent: EventNode?
    private var pharmacies: [PharmacyModel] = []
    
    private let provider = DataManager<MapAPI, PharmacyResponse>()
    
    private var segment: PharmacySegment = .map
    
    init(parent: EventNode?, medicineId: Int) {
        self.eventNodeParent = parent
        self.medicineId = medicineId
        super.init(parent: parent)
    }
}

extension PharmacyMapListContainerModel: PharmacyMapListContainerInput {
    func getPharmacies() -> [PharmacyModel] {
        return pharmacies
    }
    
    func getEventNodeParent() -> EventNode? {
        return eventNodeParent
    }
    
    func getMedicineId() -> Int {
        return self.medicineId
    }
    
    func changeSegment(to index: Int) {
        guard let segment = PharmacySegment(rawValue: index) else { return }
        self.segment = segment
        output?.segmentDidChange(to: self.segment)
    }
    
    func load() {
        provider.load(target: .getPharmacies(medicineId: medicineId,
                //TODO: - обработать
            regionId: Int(UserSession.shared.userRegionId ?? 0),
            page: Const.startPage,
            pageCount: Const.itemsPerPage),
            completion: { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.pharmacies = response.pharmacies
                self.output?.pharmaciesDidLoad()
            case .failure(let error):
                print(error.localizedDescription)
                self.output?.loadingError()
            }
        })
    }
}

private extension PharmacyMapListContainerModel {
    struct Const {
        static let startPage: Int = 1
        static let itemsPerPage: Int = 10
    }
}
