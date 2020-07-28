//
//  WelcomeViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 27.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class WelcomeViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var barCodeButton: UIButton!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var ordersStackView: UIStackView!
    
    @IBOutlet var stackViewSpaceConstr: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeightConstr: NSLayoutConstraint!
    
    @IBOutlet weak var askLabel: UILabel!
    @IBOutlet weak var diagnosticLabel: UILabel!
    @IBOutlet weak var mapLabel: UILabel!
    
    @IBOutlet var buttonsBackground: [UIView]!
    
    @IBOutlet weak var loadReceipeButton: UIButton!
    @IBOutlet weak var watchCategoriesButton: UIButton!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var watchRecentlyLabel: UILabel!
    
    var model: WelcomeModelInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocalization()
        setupUI()
        model.loadReadyOrders()
    }
    
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
