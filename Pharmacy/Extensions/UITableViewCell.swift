//
//  UITableViewCell.swift
//  KyivPost
//
//  Created by Anton Bal’ on 13.07.2020.
//  Copyright © 2020 KyivPost. All rights reserved.
//

import UIKit

extension UITableViewCell {
    var tableView: UITableView? { superview as? UITableView }
    
    func hideSeparator() {
        separatorInset = UIEdgeInsets.only(left: UIScreen.main.bounds.width)
    }

    func showSeparator() {
        guard let tableView = tableView else { return }
        separatorInset = tableView.separatorInset
    }
}
