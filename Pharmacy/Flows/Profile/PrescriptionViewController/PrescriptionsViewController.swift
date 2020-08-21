//
//  PrescriptionsViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 20.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class PrescriptionsViewController: UIViewController {

    var model: PrescriptionsInput!
    private var emptyResultsView: EmptyResultsView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        applyEmptyStyle()
        setupUI()
    }

    private func applyEmptyStyle() {
        
        let emptyView: EmptyResultsView = EmptyResultsView.fromNib()
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyView)
        emptyView.constraintsToSuperView()
        
        emptyView.setup(title: R.string.localize.prescriptionsEmptyTitle(), decriptionText: R.string.localize.prescriptionsEmptyDescription(), buttonTitle: R.string.localize.prescriptionsEmptyButton())
        
        emptyResultsView = emptyView
    }
    
    private func setupUI() {
        if let bar = navigationController?.navigationBar as? SimpleNavigationBar {
            bar.title = R.string.localize.myOrdersEmptyBarTitle()
            bar.isLeftItemHidden = false
            bar.isRightItemHidden = true
            bar.barDelegate = self
        }
    }
}

extension PrescriptionsViewController: SimpleNavigationBarDelegate {
    func leftBarItemAction() {
        model.close()
    }
    
    func rightBarItemAction() {
    }
}
