//
//  ClinicModel.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 23.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation

struct ClinicModel: Codable {
    var clinicName: String?
    var adressClinic: String?
    var imageClinic: String?
    var priceClinic: String?
    
    enum Keys: String, CodingKey {
        case clinicName
        case adressClinic
        case imageClinic
        case priceClinic
    }
    
    init(clinicName: String,
         adressClinic: String,
         imageClinic: String,
         priceClinic: String
    ) {
        self.clinicName = clinicName
        self.adressClinic = adressClinic
        self.imageClinic = imageClinic
        self.priceClinic = priceClinic
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        clinicName = try? container.decode(String.self, forKey: .clinicName)
        adressClinic = try? container.decode(String.self, forKey: .adressClinic)
        imageClinic = try? container.decode(String.self, forKey: .imageClinic)
        priceClinic = try? container.decode(String.self, forKey: .priceClinic)
    }
}
