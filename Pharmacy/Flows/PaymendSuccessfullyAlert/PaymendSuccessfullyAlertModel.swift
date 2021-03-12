//
//  PaymendSuccessfullyAlertModel.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 12.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation
import Foundation
import EventsTree


protocol PaymendSuccessfullyAlertModelInput: class {
    func close()
    
}

protocol PaymendSuccessfullyAlertModelOutput: class {

}


final class PaymendSuccessfullyAlertModel: Model {
    
    weak var output: PaymendSuccessfullyAlertModelOutput!
  
}

extension PaymendSuccessfullyAlertModel: PaymendSuccessfullyAlertControllerOutput {
    func close() {
        raise(event: AnalysisAndDiagnosticsModelEvent.dismis)
    }
}
