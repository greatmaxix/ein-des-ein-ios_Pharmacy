//
//  ChooseLocationViewController.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 28.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import UIKit

protocol ChooseLocationViewControllerInput: ChooseLocationViewModelOutput {}
protocol ChooseLocationViewControllerOutput: ChooseLocationViewModelInput {}

class ChooseLocationViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var model: ChooseLocationViewControllerOutput!
    
    private enum GUI {
        static let backgroundColor = R.color.welcomeBlue()?.withAlphaComponent(0.1)
        static let textColor = R.color.welcomeBlue()
        static let textFont = UIFont.systemFont(ofSize: 14)
    }
    
// MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavBar()
        model.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        PulseLoaderService.showAdded(to: view)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = GUI.backgroundColor

        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionIndexColor = .black
        tableView.register(UINib(nibName: String(describing: ChooseLocationTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ChooseLocationTableViewCell.self))
    }
    
    private func setupNavBar() {
    navigationController?.isNavigationBarHidden = false
      if let bar = navigationController?.navigationBar as? SimpleNavigationBar {
        bar.style = .search
        bar.setup(placeholder: R.string.localize.regionSearchBarPlaceholder.localized())
        bar.barDelegate = self
        bar.isLeftItemHidden = false
        bar.title = R.string.localize.regionTitle.localized()
        bar.leftItemTitle = model.getNavBarTitle()
      }
    }

    // MARK: - IBAction
    @IBAction func useCurrentLocation(_ sender: UIButton) {
        //model.startLocationTracking()
        //model.openAuthSlide()
        //model.close()
    }
}

// MARK: - TableViewDataSource & Delegate

extension ChooseLocationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.tableViewSections[section].items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.tableViewSections.count
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.backgroundColor = .clear
        view.tintColor = .clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(at: indexPath, cellType: ChooseLocationTableViewCell.self)
        cell.selectionStyle = .none
        let item = model.tableViewSections[indexPath.section].items[indexPath.row]
        cell.apply(title: item.name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        model.tableViewSections[section].header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.selected(indexPath: indexPath)
    }
}

extension ChooseLocationViewController: ChooseLocationViewModelOutput {
    
    func searchActionReloading() {
        UIView.transition(with: tableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: {[weak self] in
                            self?.tableView.reloadData() })
    }
    
    func reloadTableViewData(state: Bool) {
        PulseLoaderService.hide(from: view)
        
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.fillMode = CAMediaTimingFillMode.removed
        transition.duration = 0.3

        transition.subtype = state ? CATransitionSubtype.fromLeft : CATransitionSubtype.fromRight
        self.tableView.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")

        self.tableView.reloadData()
    }
    
    func applyTableViewCell(indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ChooseLocationTableViewCell else {return}
        cell.selectedCell()
        let region = model.tableViewSections[indexPath.section].items[indexPath.row]
        model.applyRegion(regionId: region.regionId)
    }
}

// MARK: - SimpleNavigationBarDelegate  

extension ChooseLocationViewController: SimpleNavigationBarDelegate {
    
    func leftBarItemAction() {
        if model.screenState {
            PulseLoaderService.showAdded(to: view)
            model.load()
        } else {
            model.close()
        }
    }
  
    func rightBarItemAction() {
        
    }
    
    func search(returnText: String) {
        model.filterRegions(searchText: returnText)
    }
    
    func cancelSearch() {
        model.filterRegions(searchText: "")
    }
}
