//
//  PrescriptionsViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 20.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class PrescriptionsViewController: UIViewController {

    var model: PrescriptionsInput!
    private var emptyResultsView: EmptyResultsView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initEmptyStyle()
        setupUI()
    }

    private func initEmptyStyle() {
        emptyResultsView = setupEmptyView(title: R.string.localize.prescriptionsEmptyTitle(),
                                          decriptionText: R.string.localize.prescriptionsEmptyDescription(),
                                          buttonTitle: R.string.localize.prescriptionsEmptyButton(),
                                          imageName: "emptyReciept",
                                          actionHandler: {[weak self] in
                                            self?.model.signUpAnalysis()})
    }
    
    private func setupUI() {
        if let bar = navigationController?.navigationBar as? SimpleNavigationBar {
            
            bar.title = R.string.localize.prescriptionsEmptyBarTitle()
            bar.isLeftItemHidden = false
            bar.leftItemTitle = nil
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
