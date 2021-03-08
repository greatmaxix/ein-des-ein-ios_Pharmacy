//
//  PromocodView.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 04.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation

protocol PromocodModelInput: class {
    func use()
    func close()
}

protocol PromocodModelOutput: class {
    func didLoad(models: [PaymentModel])
    func didFetchError(error: Error)
}


final class PromocodModel: Model, PromocodViewControllerOutput {
    weak var output: PromocodModelOutput!
    
    func use() {
//        raise(event: AnalysisAndDiagnosticsModelEvent.back)
    }
    
    func close() {
        raise(event: AnalysisAndDiagnosticsModelEvent.back)
    }
}
