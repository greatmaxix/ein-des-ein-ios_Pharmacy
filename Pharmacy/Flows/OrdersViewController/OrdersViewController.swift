//
//  OrdersViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 20.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol OrdersViewControllerInput: OrdersListOutput {}
protocol OrdersViewControllerOutput: OrdersListInput {}

final class OrdersViewController: UIViewController {

    var model: OrdersViewControllerOutput!

    private lazy var activityIndicator: MBProgressHUD = {
        let hud = MBProgressHUD(view: view)
        hud.contentColor = .gray
        hud.backgroundView.style = .solidColor
        hud.backgroundView.color = UIColor.black.withAlphaComponent(0.2)
        hud.removeFromSuperViewOnHide = false
        view.addSubview(hud)

        return hud
    }()

    private var emptyResultsView: EmptyResultsView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        model.initialLoad()

        activityIndicator.show(animated: true)
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
    func complete(isEmpty: Bool, error: String?) {
        if isEmpty == true {
            applyEmptyStyle()
        }

        activityIndicator.hide(animated: true)
    }
}

extension OrdersViewController: SimpleNavigationBarDelegate {
    func leftBarItemAction() {
        model.close()
    }
    
    func rightBarItemAction() {
    }
}
