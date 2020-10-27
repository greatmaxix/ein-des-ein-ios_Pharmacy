//
//  ScanCoordinator.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 19.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import EventsTree

struct ScanFlowConfiguration {
    let parent: EventNode
}

final class ScanCoordinator: EventNode, Coordinator {
    
    func createFlow() -> UIViewController {
        let root =  R.storyboard.scan.instantiateInitialViewController()!
        let model = ScanModel(parent: self)
        root.hidesBottomBarWhenPushed = true
        root.model = model
        model.output = root
        return root
    }
    
    init(configuration: ScanFlowConfiguration) {
        super.init(parent: configuration.parent)
        
        addHandler { (_: ScanModelEvent) in
            
        }
    }
}
