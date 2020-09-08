//
//  RequestConvertible.swift
//  Pharmacy
//
//  Created by Sapa Denys on 08.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Moya

protocol RequestConvertible: TargetType, AccessTokenAuthorizable {
    
    func baseURL()
}
