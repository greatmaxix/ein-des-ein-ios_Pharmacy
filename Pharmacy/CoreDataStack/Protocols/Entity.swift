//
//  Entity.swift
//  Pharmacy
//
//  Created by Sapa Denys on 03.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

public protocol Entity: AnyObject {
    static var primaryKey: String { get }
}
