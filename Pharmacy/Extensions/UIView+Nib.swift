//
//  UIView+Nib.swift
//  KyivPost
//
//  Created by Anton Bal’ on 09.07.2020.
//  Copyright © 2020 KyivPost. All rights reserved.
//

import UIKit

extension UIView {
    static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: Bundle.main)
    }
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        // swiftlint:disable force_cast
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    @discardableResult
    func configFromNib<T: UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
            return nil
        }
        
        addSubview(contentView)
        
        return contentView
    }
}
