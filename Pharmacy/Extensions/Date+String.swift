//
//  Date+String.swift
//  Pharmacy
//
//  Created by Egor Bozko on 19.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation

extension Date {
    var dayNameString: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE"
        return f.string(from: self)
    }
    
    var timeString: String {
        let f = DateFormatter()
        f.dateFormat = "h:mm"
        return f.string(from: self)
    }
    
    var dateCompactString: String {
        let f = DateFormatter()
        f.dateFormat = "yyyy/dd/MM"
        return f.string(from: self)
    }
}
