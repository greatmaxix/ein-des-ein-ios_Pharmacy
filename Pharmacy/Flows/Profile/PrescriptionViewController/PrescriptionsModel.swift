//
//  PrescriptionsModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 20.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import EventsTree

protocol PrescriptionsInput {
    func close()
    func signUpAnalysis()
}

final class PrescriptionsModel: EventNode {
    
}

extension PrescriptionsModel: PrescriptionsInput {
    func close() {
        raise(event: ProfileEvent.close)
    }
    
    func signUpAnalysis() {
        raise(event: AppEvent.presentInDev)
    }
}
