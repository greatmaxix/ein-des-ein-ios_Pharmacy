//
//  AnalizesViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 21.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class AnalizesViewController: UIViewController, NavigationBarStyled {

    var model: AnalizesInput!
    var style: NavigationBarStyle = .normalWithoutSearch
    private var emptyResultsView: EmptyResultsView?

    override func viewDidLoad() {
        super.viewDidLoad()

        initEmptyStyle()
        setupUI()
    }

    private func initEmptyStyle() {
        emptyResultsView = setupEmptyView(title: R.string.localize.analizesEmptyTitle.localized(),
                                          decriptionText: R.string.localize.analizesEmptyDescription.localized(),
                                          buttonTitle: R.string.localize.analizesEmptyButton.localized(),
                                          imageName: "emptyAnalysis",
                                          actionHandler: {[weak self] in
                                            self?.model.signUpAnalysis()})
    }

    private func setupUI() {
        if let bar = navigationController?.navigationBar as? SimpleNavigationBar {

            bar.title = R.string.localize.analizesEmptyBarTitle.localized()
            bar.isLeftItemHidden = false
            bar.leftItemTitle = nil
            bar.isRightItemHidden = true
            bar.barDelegate = self
        } else if let bar = self.navigationController?.navigationBar as? NavigationBar {
            bar.smallNavBarTitleLabel.text = R.string.localize.analizesEmptyBarTitle.localized()
        }
    }
}

extension AnalizesViewController: SimpleNavigationBarDelegate {
    func leftBarItemAction() {
        model.close()
    }
    
    func rightBarItemAction() {
    }
}
