//
//  TableDataSource.swift
//  KyivPost
//
//  Created by Anton Bal’ on 19.07.2020.
//  Copyright © 2020 KyivPost. All rights reserved.
//

import UIKit

protocol TableDataSources: UITableViewDataSource {
    associatedtype T
    var cells: [T] { get set }
    func assign(tableView: UITableView)
    func cell(for indexPath: IndexPath) -> T?
}

extension TableDataSources {
    func cell(for indexPath: IndexPath) -> T? {
        guard cells.count > indexPath.row else { return nil }
        return cells[indexPath.row]
    }
}

final class TableDataSource<T: TableCellSection>: NSObject, TableDataSources {
    
    var cells = [T]()
    
    var didApplySectionHandler: ((T) -> Void)?
    
    func assign(tableView: UITableView) {
        cells.forEach {
            if let nib = $0.cellType()?.nib {
                tableView.register(nib, forCellReuseIdentifier: $0.reuseIdentifier())
            }
        }
        
        tableView.dataSource = self
    }

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let value = cells[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: value.reuseIdentifier(), for: indexPath)
        value.apply(cell: cell)
        didApplySectionHandler?(value)
        value.config(cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let post = cells[indexPath.row]
        post.config(cell: cell)
    }
}
