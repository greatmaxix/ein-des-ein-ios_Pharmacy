//
//  AnalizesViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 21.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class AnalizesViewController: UIViewController {

    var model: AnalizesInput!
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

        emptyView.setup(title: R.string.localize.analizesEmptyTitle(), decriptionText: R.string.localize.analizesEmptyDescription(), buttonTitle: R.string.localize.analizesEmptyButton())
        
        emptyView.setupImage(image: UIImage(named: "emptyOrders")!)
        emptyView.tapButtonHandler = {[weak self] in
            self?.model.signUpAnalysis()
        }

        emptyResultsView = emptyView
    }

    private func setupUI() {
        if let bar = navigationController?.navigationBar as? SimpleNavigationBar {

            bar.title = R.string.localize.analizesEmptyBarTitle()
            bar.isLeftItemHidden = false
            bar.leftItemTitle = nil
            bar.isRightItemHidden = true
            bar.barDelegate = self
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
