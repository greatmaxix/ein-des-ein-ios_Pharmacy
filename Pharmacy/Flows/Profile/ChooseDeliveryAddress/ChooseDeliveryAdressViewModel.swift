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
    func saveDeliveryAddress(city: String, street: String,
                             house: String, pavilion: String?,
                             flat: String?, note: String?)
}

final class ChooseDeliveryAdressViewModel: Model {
    unowned var output: ChooseDeliveryAdressOutput!
    
}

extension ChooseDeliveryAdressViewModel: ChooseDeliveryAdressInput {
    
    func saveDeliveryAddress(city: String, street: String,
                             house: String, pavilion: String?,
                             flat: String?, note: String?) {
        let address = DeliveryAddressDTO.init(city: city, street: street, house: house, pavilion: pavilion, flat: flat, note: note)
        UserSession.shared.save(deliveryAddress: address)
        successSaveDelivaryAdress()
    }
    
    private func successSaveDelivaryAdress() {
        self.raise(event: EditProfileEvent.profileUpdated)
        self.raise(event: EditProfileEvent.close)
    }
    
    func close() {
        raise(event: AboutAppEvent.close)
    }
}
