//
//  WelcomeViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 27.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class WelcomeViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var barCodeButton: UIButton!
    @IBOutlet private weak var searchTextfield: UITextField!
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var ordersStackView: UIStackView!
    
    @IBOutlet fileprivate weak var stackViewSpaceConstr: NSLayoutConstraint!
    @IBOutlet fileprivate weak var stackViewHeightConstr: NSLayoutConstraint!
    
    @IBOutlet private weak var askLabel: UILabel!
    @IBOutlet private weak var diagnosticLabel: UILabel!
    @IBOutlet private weak var mapLabel: UILabel!
    
    @IBOutlet private var buttonsBackground: [UIView]!
    
    @IBOutlet private weak var loadReceipeButton: UIButton!
    @IBOutlet private weak var watchCategoriesButton: UIButton!
    @IBOutlet private weak var categoriesLabel: UILabel!
    @IBOutlet private weak var watchRecentlyLabel: UILabel!
    
    var model: WelcomeModelInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocalization()
        setupUI()
        model.loadReadyOrders()
    }
    
    // MARK: - Setup
    
    private func setupLocalization() {
        
        titleLabel.text = R.string.localize.welcomeTitle()
        askLabel.text = R.string.localize.welcomeAsk()
        diagnosticLabel.text = R.string.localize.welcomeDiagnostic()
        mapLabel.text = R.string.localize.welcomeMap()
        
        loadReceipeButton.setTitle(R.string.localize.welcomeReceipe(), for: .normal)
        watchCategoriesButton.setTitle(R.string.localize.welcomeWatch_all(), for: .normal)
        categoriesLabel.text = R.string.localize.welcomeCategories()
        watchRecentlyLabel.text = R.string.localize.welcomeWatchRecently()
    }
    
    private func setupUI() {
        
        navigationController?.isNavigationBarHidden = true
        headerView.layer.cornerRadius = 10
        headerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        barCodeButton.layer.cornerRadius = 6
        buttonsBackground.forEach({
            $0.layer.cornerRadius = 10
            $0.dropBlueShadow()
        })
        
        loadReceipeButton.dropBlueShadow()
        searchView.layer.cornerRadius = searchView.bounds.height / 2
        loadReceipeButton.layer.cornerRadius = loadReceipeButton.frame.height / 2
    }
    
    // MARK: Actions
    
    @IBAction private func selectCategory(_ sender: UIButton) {
        model.openCategories()
    }
    
}

extension WelcomeViewController: WelcomeModelOutput {
    
    func showReadyOrders(orders: [String]) {
        
        stackViewSpaceConstr.isActive = orders.count == 0
        ordersStackView.isHidden = orders.count == 0
        
        ordersStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        
        var height: CGFloat = 0
        
        for order in orders {
            
            if let orderView: ReadyOrderView = R.nib.readyOrderView(owner: nil) {
                orderView.orderNumber = order
                ordersStackView.addArrangedSubview(orderView)
                height += orderView.frame.height
            }
        }
        
        stackViewHeightConstr.constant = height + CGFloat(max(orders.count - 1, 0)) * 10
    }
}
