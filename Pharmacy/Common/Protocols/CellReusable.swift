//
//  CellReusable.swift
//  Pharmacy
//
//  Created by Sapa Denys on 02.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

protocol CellReusable: class {
    static var reuseIdentifier: String { get }
}

extension CellReusable {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
