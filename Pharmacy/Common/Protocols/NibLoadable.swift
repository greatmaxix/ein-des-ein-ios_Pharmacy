//
//  NibLoadable.swift
//  Pharmacy
//
//  Created by Sapa Denys on 02.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol NibLoadable: class {
    static var nib: UINib { get }
    static var nibView: UIView { get }
}

extension NibLoadable {
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    static var nibView: UIView {
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            fatalError("Can't instantiate a \(self)")
        }
        
        return view
    }
}

extension NibLoadable {
    
    static func loadNib<T>() -> T {
        guard let view = nibView as? T else {
            fatalError("Can't instantiate a \(self)")
        }
        
        return view
    }
}
