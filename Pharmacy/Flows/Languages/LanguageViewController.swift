//
//  LanguageViewController.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 10.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

protocol LanguageViewControllerOutput: LanguageViewModelInput {}
protocol LanguageViewControllerInput: LanguageViewModelOutput {}

class LanguageViewController: UIViewController, NavigationBarStyled {
        
    var style: NavigationBarStyle = .normalWithoutSearch
    
    var model: LanguageViewControllerOutput!
    private var models: [LaboratoryResearchModel] = []
    
    @IBOutlet var tableView: UITableView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupTableView()
        model.load()
    }
    
    private func configUI() {
        tableView?.separatorStyle = .none
        tableView?.delegate = self
        tableView?.dataSource = self
        
        if let bar = navigationController?.navigationBar as? SimpleNavigationBar {
            bar.barDelegate = self
            bar.leftItemTitle = nil
            bar.title =  R.string.localize.profileLanguage.localized()
            bar.isLeftItemHidden = false
        }
    }
    
    func setBarTitle() {
        if let bar = navigationController?.navigationBar as? SimpleNavigationBar {
            bar.title =  R.string.localize.profileLanguage.localized()
        }
    }
}


extension LanguageViewController {
    private func setupTableView() {
        self.tableView?.register(UINib(resource: R.nib.languageTableViewCell),
                           forCellReuseIdentifier: String(describing: LanguageTableViewCell.self))
    }
}


extension LanguageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.languageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(at: indexPath, cellType: LanguageTableViewCell.self)
        let model = self.model.languageList[indexPath.row]
        let selected = LanguageService.current.getCurrentLanguageModel().languageCode == model.languageCode
        cell.apply(languageModel: model, selected: selected)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension LanguageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.didSelectCell(at: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - AnalysisAndDiagnosticsControllerInput
extension LanguageViewController: LanguageViewControllerInput {
    
    func didLoad(models: [LanguageModel]) {

    }
    
    func didSelect() {
        tableView?.reloadData()
        setBarTitle()
    }
        
    func didFetchError(error: Error) {
        
    }
}


extension LanguageViewController: SimpleNavigationBarDelegate {
    func leftBarItemAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func rightBarItemAction() {
        
    }
}
