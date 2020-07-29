//
//  CatalogsViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 28.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class CatalogsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var headerView: UIView!

    @IBOutlet private weak var searchAndCodeButton: UIButton!
    @IBOutlet private weak var cancelSearchButton: UIButton!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var searchView: UIView!
    
    var model: CatalogsModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(resource: R.nib.farmacyCell), forCellReuseIdentifier: "FarmacyCell")
        tableView.register(<#T##nib: UINib?##UINib?#>, forHeaderFooterViewReuseIdentifier: "header")
        tableView.delegate = self
        tableView.dataSource = self
        
        setupUI()
    }
    
    func setupUI() {
        
        
    }
    
    @IBAction private func close() {
        model.close()
    }
}

extension CatalogsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension CatalogsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return model.cellHeightAt(indexPath: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.rowInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: model.cellId(section: indexPath.section)) as? BaseTableViewCell, let object: Any = model.objectAt(indexPath: indexPath) {
            
            cell.setup(representObj: object)
            return cell
        }
        return UITableViewCell()
    }
}

extension CatalogsViewController: CatalogsModelOutput { }
