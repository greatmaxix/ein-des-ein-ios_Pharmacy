//
//  MapModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 25.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

protocol MapInput: class {
    
}

protocol MapOutput: class {
    
}

final class MapModel: EventNode {
    
    weak var output: MapOutput!
}

extension MapModel: MapInput {
    
}


