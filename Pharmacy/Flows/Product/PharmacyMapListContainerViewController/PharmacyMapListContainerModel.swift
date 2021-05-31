//
//  PharmacyMapListContainerModel.swift
//  Pharmacy
//
//  Created by Daniiar Erkinov on 31/5/21.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

enum PharmacySegment: Int, CaseIterable {
    case list
    case map
}

protocol PharmacyMapListContainerInput: AnyObject {
    func changeSegment(to index: Int)
}

final class PharmacyMapListContainerModel: EventNode {
    weak var output: PharmacyMapListContainerOutput?
    
    private var medicineId: Int?
    
    private var segment: PharmacySegment = .map
    
    init(parent: EventNode?, medicineId: Int) {
        super.init(parent: parent)
        
        self.medicineId = medicineId
    }
}

extension PharmacyMapListContainerModel: PharmacyMapListContainerInput {
    func changeSegment(to index: Int) {
        guard let segment = PharmacySegment(rawValue: index) else { return }
        self.segment = segment
        output?.segmentDidChange(to: self.segment)
    }
}
