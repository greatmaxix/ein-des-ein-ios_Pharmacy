//
//  UISearchBar+TextField.swift
//  Pharmacy
//
//  Created by Sapa Denys on 09.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    var textField: UITextField? {
        if #available(iOS 13, *) {
            return searchTextField
        }
        
        let subviews = self.subviews.flatMap {
            $0.subviews
        }
        
        guard let textField = (subviews.filter { $0 is UITextField
        }).first as? UITextField else {
            return nil
        }
        
        return textField
    }
}
