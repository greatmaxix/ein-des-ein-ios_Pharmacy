//
//  ChooseLocationViewController.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 28.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

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
    
    private lazy var activityIndicator: MBProgressHUD = {
        setupActivityIndicator()
    }()
    
// MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.show(animated: true)
        setupTableView()
        setupNavBar()
        model.load()
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
      if let bar = navigationController?.navigationBar as? SimpleNavigationBar {
        bar.style = .search
        bar.isLeftItemHidden = model.isProfileConfiguration
        bar.isRightItemHidden = false
        
        bar.title = R.string.localize.regionTitle()
        
        bar.leftItemTitle = model.getNavBarTitle()
        bar.barDelegate = self
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
        let item = model.tableViewSections[indexPath.section].items[indexPath.row] as? Region
        cell.apply(title: item!.name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        model.tableViewSections[section].header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.selected(indexPath: indexPath)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return model.indexForSections
    }
}

extension ChooseLocationViewController: ChooseLocationViewModelOutput {
    
    func reloadTableViewData(state: Bool) {
        activityIndicator.hide(animated: true, afterDelay: 0.3)
        
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
        let region = model.tableViewSections[indexPath.section].items[indexPath.row] as? Region
        model.applyRegion(regionId: region!.regionId)
    }
}

// MARK: - SimpleNavigationBarDelegate  

extension ChooseLocationViewController: SimpleNavigationBarDelegate {
    
    func leftBarItemAction() {
        if model.screenState {
            activityIndicator.show(animated: true)
            model.load()
        } else {
            model.close()
        }
    }
  
    func rightBarItemAction() {
    
    }
    
    func search(returnText: String) {
        model.filterRegions(searchText: returnText)
        tableView.reloadData()
    }
    
    func cancelSearch() {
        model.filterRegions(searchText: "")
        tableView.reloadData()
    }
}
