//
//  SearchViewController.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 07.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol SearchViewControllerInput: SearchModelOutput {}
protocol SearchViewControllerOutput: SearchModelInput {}

final class SearchViewController: UIViewController, NavigationBarStyled {

    private enum GUI {
        static let backgroundColor = R.color.welcomeBlue()?.withAlphaComponent(0.1)
        static let textColor = R.color.welcomeBlue()
        static let textFont = UIFont.systemFont(ofSize: 14)
    }
    
    @IBOutlet private weak var cleanButton: UIButton!
    @IBOutlet private weak var storyLabel: UILabel!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var emptyView: EmptySearchView!
    
    private let searchBar = SearchBar()
    
    private lazy var activityIndicator: MBProgressHUD = {
        let hud = MBProgressHUD(view: view)
        hud.backgroundView.style = .solidColor
        hud.backgroundView.color = UIColor.black.withAlphaComponent(0.2)
        hud.removeFromSuperViewOnHide = false
        view.addSubview(hud)
        
        return hud
    }()
    
    var style: NavigationBarStyle = .search
    
    var model: SearchViewControllerOutput!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupTableView()
        setupNavigationBar()
        model.load()
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
extension SearchViewController {
    
    private func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        
        navigationBar.tintColor = .white
        navigationBar.backgroundColor = .clear
        navigationBar.setBackgroundImage(R.image.navigationBar()?.stretchableImage(withLeftCapWidth: 20,
                                                                                   topCapHeight: 20),
                                         for: .default)
        navigationBar.shadowImage = UIImage()
        
        searchBar.delegate = self
        searchBar.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        navigationItem.titleView = searchBar
        searchBar.topAnchor.constraint(equalTo: searchBar.superview!.topAnchor).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: searchBar.superview!.bottomAnchor, constant: -8.0).isActive = true
    }
    
    private func setupTableView() {
        tableView.register(viewType: RecentsHeaderView.self)
        tableView.register(cellType: SearchTableViewCell.self)
        tableView.register(cellType: MedicineCell.self)
    }
}

// MARK: - SearchViewControllerInput
extension SearchViewController: SearchViewControllerInput {
    
    func favoriteAciontReloadCell(cellAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func addRemoveFromFavoriteError(indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MedicineCell else {return}
        cell.setPreviousFavoriteButtonState()
    }
    
    func willSendRequest() {
        activityIndicator.show(animated: true)
    }
    
    func retrivesNewResults() {
        if case .empty = model.searchState {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }
        
        tableView.reloadData()
        
        activityIndicator.hide(animated: true)
    }
    
    func retreivingMoreMedicinesDidEnd() {
        activityIndicator.hide(animated: true)
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
        searchBar.endEditing(false)
        searchBar.textField.text = term
    }
    
    func beginSearch() {
        self.searchBar.textField.becomeFirstResponder()
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch model.searchState {
//        case .recents:
//            return model.recentRequests.count
        case .found:
            return model.medicines.count
        default:
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch model.searchState {
//        case .recents:
//            let cell = tableView.dequeueReusableCell(at: indexPath, cellType: SearchTableViewCell.self)
//            cell.apply(title: model.recentRequests[indexPath.row])
//
//            return cell
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch model.searchState {
//        case .recents:
//            return 44
        default:
            return .zero
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        switch model.searchState {
//        case .recents:
//            guard model.recentRequests.count > 0 else {
//                return UIView()
//            }
//
//            let headerView = tableView.dequeueReusableView(viewType: RecentsHeaderView.self)
//            headerView.clearActionHandler = { [unowned self] in
//                self.cleanAction()
//            }
//
//            return headerView
//        default:
//            return UIView()
//        }
//    }
}

// MARK: - UITableViewDataSourcePrefetching
extension SearchViewController: UITableViewDataSourcePrefetching {

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
        
        activityIndicator.show(animated: true)
        
        model.retreiveMoreMedecines()
    }
}

// MARK: - SearchBarDelegate
extension SearchViewController: SearchBarDelegate {
    
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
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        model.didSelectCellAt(indexPath: indexPath)
    }
}
