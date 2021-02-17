//
//  AnalysisAndDiagnostics.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 17.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

class AnalysisAndDiagnostics: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var topNavBarView: UIView?
    var model: SearchViewControllerOutput!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topNavBarView?.layer.cornerRadius = 10
        self.topNavBarView?.layer.masksToBounds = true
    //    configUI()
    ///    setupTableView()
    //    setupNavigationBar()
      //  model.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func configUI() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
    }
    
// MARK: - Actions
    private func cleanAction() {
        showAlert(title: R.string.localize.searchCleanTitle(),
                  message: R.string.localize.searchCleanMessage(),
                  action: AlertAction(title: R.string.localize.actionClean(), callback: model.cleanSearchTerm),
                  cancelStyleAction: AlertAction(title: R.string.localize.actionCancel(), callback: {}))
    }
}

// MARK: - Private methods
extension AnalysisAndDiagnostics {
    
    private func setupTableView() {
       // tableView.register(cellType: SearchTableViewCell.self)
        //tableView.register(cellType: MedicineCell.self)
    }
    
    @objc private func tapScan() {
        model.openScan()
    }
}

// MARK: - SearchViewControllerInput
extension AnalysisAndDiagnostics: SearchViewControllerInput {
    
    func favoriteAciontReloadCell(cellAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func addRemoveFromFavoriteError(indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MedicineCell else {return}
        cell.setPreviousFavoriteButtonState()
    }
    
    func willSendRequest() {
//       // activityIndicator.show(animated: true)
    }
//
    func retrivesNewResults() {
//        if case .empty = model.searchState {
//            emptyView.isHidden = false
//        } else {
//            emptyView.isHidden = true
//        }
//
//        tableView.reloadData()
//
//        activityIndicator.hide(animated: true)
    }
    
    func retreivingMoreMedicinesDidEnd() {
      //  activityIndicator.hide(animated: true)
    }
    
    func didLoadRecentRequests() {
        guard isViewLoaded else {
            return
        }
        
        tableView.reloadData()
    }
    
    func needToInsertNewMedicines(at indexPathes: [IndexPath]?) {
        guard let indexPathes = indexPathes else {
            tableView.isHidden = false
            tableView.reloadData()
            
            return
        }

        tableView.beginUpdates()
        tableView.insertRows(at: indexPathes,
                             with: .automatic)
        tableView.endUpdates()
    }
    
    func searchTermDidUpdated(_ term: String?) {
       // searchBar.endEditing(false)
       // searchBar.textField.text = term
    }
    
    func beginSearch() {
       // self.searchBar.textField.becomeFirstResponder()
    }
}

extension AnalysisAndDiagnostics: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch model.searchState {
        case .found:
            return model.medicines.count
        default:
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch model.searchState {
        case .found:
            let cell = tableView.dequeueReusableCell(at: indexPath, cellType: MedicineCell.self)
            cell.apply(medicine: model.medicines[indexPath.row])
            cell.favoriteButtonHandler = {[weak self] state in
                if state {
                    self?.model.addToWishList(productId: cell.medicineProductID, indexPath: indexPath)
                } else {
                    self?.model.removeFromWishList(productId: cell.medicineProductID, indexPath: indexPath)
                }
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
////        switch model.searchState {
////        default:
////            return .zero
////        }
//    }
}

// MARK: - UITableViewDataSourcePrefetching
extension AnalysisAndDiagnostics: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard case .found = model.searchState else {
            return
        }
        
        let isEndOfList = indexPaths.contains {
            $0.row == model.medicines.count - 1
        }
        
        guard isEndOfList else {
            return
        }
        
        //activityIndicator.show(animated: true)
        
        model.retreiveMoreMedecines()
    }
}

// MARK: - SearchBarDelegate
extension AnalysisAndDiagnostics: SearchBarDelegate {
    
    func searchBar(_ searchBar: SearchBar, textDidChange searchText: String) {
        model.updateSearchTerm(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: SearchBar) {
        searchBar.endEditing(false)
        model.processSearch()
    }
    
    func searchBarDidCancel() {
        model.cleanSearchTerm()
    }
}

// MARK: - UITableViewDelegate
extension AnalysisAndDiagnostics: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        model.didSelectCellAt(indexPath: indexPath)
    }
}

