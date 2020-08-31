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
    @IBOutlet private weak var tableView: UITableView!

    private let config = TTGTextTagConfig()
    
    var style: NavigationBarStyle = .search
    
    var model: SearchViewControllerOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        model.load()
    }
    
    func configUI() {
        config.backgroundColor = GUI.backgroundColor
        config.textColor = GUI.textColor
        config.textFont = GUI.textFont
        config.borderWidth = 0
        config.shadowColor = .clear
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
    }
    
// MARK: - Actions
    
    @IBAction private func cleanAction(_ sender: UIButton) {
        showAlert(title: R.string.localize.searchCleanTitle(),
                  message: R.string.localize.searchCleanMessage(),
                  action: AlertAction(title: R.string.localize.actionClean(), callback: model.cleanStory),
                  cancelStyleAction: AlertAction(title: R.string.localize.actionCancel(), callback: {}))
    }
}

// MARK: - SearchViewControllerInput

extension SearchViewController: SearchViewControllerInput {
    func didLoad(story: TableDataSource<SearchCellSection>) {
        story.assign(tableView: tableView)
        tableView.reloadData()
        cleanButton.isHidden = story.cells.isEmpty
        storyLabel.isHidden = story.cells.isEmpty
    }
    
    func didLoad(tags: [String]) {
        tagsCollectionView.removeAllTags()
        tagsCollectionView.addTags(tags, with: config)
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        model.didSelectCellAt(indexPath: indexPath)
    }
}
