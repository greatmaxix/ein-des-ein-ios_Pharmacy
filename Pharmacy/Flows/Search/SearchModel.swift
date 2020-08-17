//
//  SearchModel.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 07.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

enum SearchModelEvent: Event { }

protocol SearchModelInput: class {
    
}

protocol SearchModelOutput: class {}

final class SearchModel: Model {
    
    weak var output: SearchModelOutput!
    
}

//MARK: - SearchViewControllerOutput

extension SearchModel: SearchViewControllerOutput {
    
}

