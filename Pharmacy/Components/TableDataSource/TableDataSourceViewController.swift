//
//  TableDataSourceViewController.swift
//  KyivPost
//
//  Created by Anton Bal’ on 24.07.2020.
//  Copyright © 2020 KyivPost. All rights reserved.
//

import UIKit

class TableDataSourceViewController: UIViewController {
    
    let tableConstraintInsets: UIEdgeInsets
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView)
        tableView.constraintsToSuperView(insets: tableConstraintInsets)
        return tableView
    }()
    
    init(tableConstraintInsets: UIEdgeInsets = .zero) {
        self.tableConstraintInsets = tableConstraintInsets
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func assign<T>(dataSource: TableDataSource<T>) {
        dataSource.assign(tableView: tableView)
    }
}
