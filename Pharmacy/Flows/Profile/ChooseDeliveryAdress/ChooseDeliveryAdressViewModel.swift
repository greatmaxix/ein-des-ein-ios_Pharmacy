//
//  ChooseDeliveryAdressViewModel.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 02.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

protocol ChooseDeliveryAdressOutput: class {
}

protocol ChooseDeliveryAdressInput: class {
    func close()
}

final class ChooseDeliveryAdressViewModel: Model {
    
    unowned var output: ChooseDeliveryAdressOutput!
    
}

extension ChooseDeliveryAdressViewModel: ChooseDeliveryAdressInput {
    
    func close() {
        raise(event: AboutAppEvent.close)
    }
}
