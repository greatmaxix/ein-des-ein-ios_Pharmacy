//
//  UserSessionDataAccessible.swift
//  Pharmacy
//
//  Created by Sapa Denys on 03.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

protocol UserSessionDataAccessible {
    
    static var apiHost: String { get set }
    static var userId: Int { get set }
    
    static func removeUserId()
    static func clear()
}
