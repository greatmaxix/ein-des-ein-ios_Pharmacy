//
//  SearchNavigationModel.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 19.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

enum SearchNavigationModelEvent: Event {
    case openScan
    case openList
}

protocol SearchNavigationModelInput: ControllerVisibilityOutput {
    func openScan()
    func searchBy(text: String)
}

protocol SearchNavigationModelOutput: class {}

final class SearchNavigationModel: Model {
    
    weak var output: SearchNavigationModelOutput!
    
}

// MARK: - SearchNavigationViewControllerOutput

extension SearchNavigationModel: SearchNavigationControllerOutput {
    func searchBy(text: String) {
        raise(event: SearchNavigationModelEvent.openList)
    }
    
    func openScan() {
        raise(event: SearchNavigationModelEvent.openScan)
    }
}
