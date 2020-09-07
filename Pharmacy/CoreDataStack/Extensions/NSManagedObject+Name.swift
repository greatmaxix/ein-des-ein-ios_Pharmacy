//
//  NSManagedObject+Name.swift
//  Pharmacy
//
//  Created by Sapa Denys on 03.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import CoreData

public extension NSManagedObject {

    // MARK: - Static Properties
    static var entityName: String { return className  }
}

extension NSObject {

    public class var className: String {
        return String(describing: self)
    }
}
