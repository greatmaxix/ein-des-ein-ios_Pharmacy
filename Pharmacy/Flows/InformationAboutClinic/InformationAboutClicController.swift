//
//  InformationAboutClicController.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 26.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

protocol InformationAboutClicControllerInput: InformationAboutClicModelOutput {}
protocol InformationAboutClicControllerOutput: InformationAboutClicModelInput {}

class InformationAboutClicController: UIViewController, NavigationBarStyled {
    
    var style: NavigationBarStyle = .normalWithoutSearch
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var tableHeight: NSLayoutConstraint!
    
    private var tableAdapter: TableAdapter?
    
    var model: InformationAboutClicControllerOutput!    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        model.configureTableView(tableView)
        model.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    private func setupUI() {
        if let bar = self.navigationController?.navigationBar as? NavigationBar {
            bar.smallNavBarTitleLabel.text = "Information About"
        }
    }
}

// MARK: - AnalysisAndDiagnosticsControllerInput
extension InformationAboutClicController: InformationAboutClicControllerInput {
    
    func didFetchTableHeight(_ height: CGFloat) {
        tableHeight.constant = height
    }
    
    func didFetchError(error: Error) {
        
    }
    
    func didLoad() {
        
    }
}

extension InformationAboutClicController: SimpleNavigationBarDelegate {
    
    func leftBarItemAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func rightBarItemAction() {
        
    }
}
