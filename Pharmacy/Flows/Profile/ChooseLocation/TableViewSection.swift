//
//  TableViewSection.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 28.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

struct TableViewSection<T> {
    var header: String?
    var footer: String?
    var items: [T]
    
    private var uuid = UUID()
    
    init(header: String? = nil, footer: String? = nil, list: [T]) {
        self.header = header
        self.footer = header
        self.items = list
    }
    
}
