//
//  OrdersViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 20.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol OrdersViewControllerInput: OrdersListOutput {}
protocol OrdersViewControllerOutput: OrdersListInput {}

final class OrdersViewController: UIViewController {

    var model: OrdersViewControllerOutput!

    private var emptyResultsView: EmptyResultsView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        applyEmptyStyle()
        setupUI()

        model.initialLoad()
    }

    private func applyEmptyStyle() {
        
        let emptyView: EmptyResultsView = EmptyResultsView.fromNib()
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyView)
        emptyView.constraintsToSuperView()
        
        emptyView.setup(title: R.string.localize.myOrdersEmptyTitle(), decriptionText: R.string.localize.myOrdersEmptyDescription(), buttonTitle: R.string.localize.myOrdersEmptyButton())
        
        emptyResultsView = emptyView
    }
    
    private func setupUI() {
        if let bar = navigationController?.navigationBar as? SimpleNavigationBar {
            bar.title = R.string.localize.myOrdersEmptyBarTitle()
            bar.isLeftItemHidden = false
            bar.leftItemTitle = nil
            bar.isRightItemHidden = true
            bar.barDelegate = self
        }
    }
    
}

extension OrdersViewController: OrdersViewControllerInput {
    
}

extension OrdersViewController: SimpleNavigationBarDelegate {
    func leftBarItemAction() {
        model.close()
    }
    
    func rightBarItemAction() {
    }
}
