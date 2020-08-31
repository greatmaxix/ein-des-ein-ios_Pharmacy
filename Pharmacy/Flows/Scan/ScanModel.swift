//
//  ScanModel.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 19.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

enum ScanModelEvent: Event { }

protocol ScanModelInput: class {
    var isShouldShowPreview: Bool { get }
    func searchItemBy(code: String)
}

protocol ScanModelOutput: class {
    func didFoundItem(item: String?)
}

final class ScanModel: Model {
    
    weak var output: ScanModelOutput!
    
}

// MARK: - ScanViewControllerOutput

extension ScanModel: ScanViewControllerOutput {
    var isShouldShowPreview: Bool {
        true
    }
    
    func searchItemBy(code: String) {
        output.didFoundItem(item: code)
    }
}
