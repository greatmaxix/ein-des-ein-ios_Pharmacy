//
//  CatalogsViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 28.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class CatalogsViewController: UIViewController, NavigationBarStyled {

    @IBOutlet private weak var tableView: UITableView!
    
    var model: CatalogsModel!
    
    var style: NavigationBarStyle = .normal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        title = R.string.localize.tabbarCatalogue()
        tableView.register(UINib(resource: R.nib.farmacyCell), forCellReuseIdentifier: "FarmacyCell")
        tableView.register(UINib(resource: R.nib.titleHeaderView), forHeaderFooterViewReuseIdentifier: "header")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionFooterHeight = 5
    }
    
    @IBAction private func close() {
        model.close()
    }
}

// MARK: - UITableViewDelegate

extension CatalogsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let titleView: TitleHeaderView = R.nib.titleHeaderView(owner: nil) else {
            return nil
        }
        
        titleView.title = model.sectionTitleAt(section: section)
        return titleView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return model.cellHeightAt(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return model.sectionTitleAt(section: section) == nil ? Const.emptyHeader : Const.headerWithText
    }
}

// MARK: - UITableViewDataSource

extension CatalogsViewController: UITableViewDataSource {
    
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

// MARK: - CatalogsModelOutput

extension CatalogsViewController: CatalogsModelOutput { }

extension CatalogsViewController {
    
    fileprivate struct Const {
        static let searchIsHidden: CGFloat = 270
        static let searchIsVisible: CGFloat = 16
        static let headerWithText: CGFloat = 60
        static let emptyHeader: CGFloat = 30
    }
}
