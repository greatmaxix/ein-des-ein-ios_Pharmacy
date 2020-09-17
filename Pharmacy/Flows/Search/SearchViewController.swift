//
//  SearchViewController.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 07.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import TTGTagCollectionView

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
    @IBOutlet private weak var tagsCollectionView: TTGTextTagCollectionView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var emptyView: EmptySearchView!
    
    private let tagCloudConfig = TTGTextTagConfig()
    
    var style: NavigationBarStyle = .search
    
    var model: SearchViewControllerOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        setupTableView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        model.retreiveResentRequests()
    }
    
    func configUI() {
        tagCloudConfig.backgroundColor = GUI.backgroundColor
        tagCloudConfig.textColor = GUI.textColor
        tagCloudConfig.textFont = GUI.textFont
        tagCloudConfig.borderWidth = 0
        tagCloudConfig.shadowColor = .clear
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
    }
    
// MARK: - Actions
    
    private func cleanAction() {
        showAlert(title: R.string.localize.searchCleanTitle(),
                  message: R.string.localize.searchCleanMessage(),
                  action: AlertAction(title: R.string.localize.actionClean(), callback: model.cleanStory),
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
        
        let searchBar = SearchBar()
        searchBar.delegate = self
        searchBar.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        navigationItem.titleView = searchBar
        searchBar.topAnchor.constraint(equalTo: searchBar.superview!.topAnchor).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: searchBar.superview!.bottomAnchor, constant: -8.0).isActive = true
    }
    
    private func setupTableView() {
        tableView.register(viewType: RecentsHeaderView.self)
        tableView.register(cellType: SearchTableViewCell.self)
    }
}

// MARK: - SearchViewControllerInput
extension SearchViewController: SearchViewControllerInput {
    
    func didLoadRecentRequests() {
        guard isViewLoaded else {
            return
        }
        
        tableView.reloadData()
    }
    
    func didLoad(tags: [String]) {
        guard isViewLoaded else {
            return
        }
        
        tagsCollectionView.removeAllTags()
        tagsCollectionView.addTags(tags, with: tagCloudConfig)
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch model.searchState {
        case .recents:
            return model.recentRequests.count
        default:
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch model.searchState {
        case .recents:
            let cell = tableView.dequeueReusableCell(at: indexPath, cellType: SearchTableViewCell.self)
            cell.apply(title: model.recentRequests[indexPath.row])
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch model.searchState {
        case .recents:
            return 44
        default:
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch model.searchState {
        case .recents:
            guard model.recentRequests.count > 0 else {
                return UIView()
            }
            
            let headerView = tableView.dequeueReusableView(viewType: RecentsHeaderView.self)
            headerView.clearActionHandler = { [unowned self] in
                self.cleanAction()
            }
            
            return headerView
        default:
            return UIView()
        }
    }
}

extension SearchViewController: SearchBarDelegate {
    
    func searchBar(_ searchBar: SearchBar, textDidChange searchText: String) {
        model.updateSearchTerm(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: SearchBar) {
        searchBar.endEditing(false)
        model.processSearch()
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        model.didSelectCellAt(indexPath: indexPath)
    }
}
