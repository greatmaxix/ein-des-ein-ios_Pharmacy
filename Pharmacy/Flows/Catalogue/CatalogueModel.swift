//
//  CatalogueModel.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 07.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

enum CatalogueModelEvent: Event { }

protocol CatalogueModelInput: class {
    
}

protocol CatalogueModelOutput: class {}

final class CatalogueModel: Model {
    
    weak var output: CatalogueModelOutput!
    
}

//MARK: - MapViewControllerOutput

extension CatalogueModel: CatalogueViewControllerOutput {
    
}
