//
//  MedicineCoordinator.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 14.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

struct MedicineListFlowConfiguration {
    let parent: EventNode
}

final class MedicineListCoordinator: EventNode, Coordinator {
    func createFlow() -> UIViewController {
        let root =  R.storyboard.catalogue.medicineListViewController()!
        let model = MedicineListModel(parent: self)
        root.model = model
        model.output = root
        return root
    }
    
    init(configuration: MedicineListFlowConfiguration) {
        super.init(parent: configuration.parent)
        
        addHandler { (event: MedicineListModelEvent) in
            
        }
    }
}
