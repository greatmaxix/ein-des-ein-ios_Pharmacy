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
    
    @IBOutlet private var leftSpaceSearchConstr: NSLayoutConstraint!
    
    var model: CatalogsModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(resource: R.nib.farmacyCell), forCellReuseIdentifier: "FarmacyCell")
        tableView.register(UINib(resource: R.nib.titleHeaderView), forHeaderFooterViewReuseIdentifier: "header")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionFooterHeight = 5
        setupUI()
    }
    
    func setupUI() {
        headerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        headerView.layer.cornerRadius = 10
        
        searchView.layer.cornerRadius = searchView.bounds.height / 2
        searchAndCodeButton.layer.cornerRadius = 6
    }
    
    @IBAction private func close() {
        model.close()
    }
    
    @IBAction private func clearTextField(_ sender: Any) {
        searchTextField.text = nil
    }
    
    @IBAction private func openSearch(_ sender: UIButton) {
        
        if !sender.isSelected {
            sender.isSelected = true
            setHeaderStyle(searchIsHidden: false)
        } else {
            
        }
    }
    
    @IBAction private func hideSearch(_ sender: UIButton) {
        searchAndCodeButton.isSelected = false
        setHeaderStyle(searchIsHidden: true)
    }
    
    private func setHeaderStyle(searchIsHidden: Bool) {
        
        searchAndCodeButton.backgroundColor = searchIsHidden ? .clear : R.color.welcomeGreen()
        
        self.leftSpaceSearchConstr.constant = searchIsHidden ? Const.searchIsHidden : Const.searchIsVisible
        self.searchAndCodeButton.isSelected = !searchIsHidden
        self.backButton.isHidden = !searchIsHidden
        
        if searchIsHidden {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.searchView.isHidden = searchIsHidden
            })
        } else {
            
            self.searchView.isHidden = searchIsHidden
            UIView.animate(withDuration: 0.3, animations: {
                
                self.view.layoutIfNeeded()
            })
        }
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
