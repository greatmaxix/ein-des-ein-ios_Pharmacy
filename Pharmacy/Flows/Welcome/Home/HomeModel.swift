//
//  HomeModel.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 08.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

enum HomeModelEvent: Event {
}

protocol HomeModelInput: class {
}

protocol HomeModelOutput: class {}

final class HomeModel: Model {
    
    weak var output: HomeModelOutput!
    
}

//MARK: - HomeViewControllerOutput

extension HomeModel: HomeViewControllerOutput {
   
}
