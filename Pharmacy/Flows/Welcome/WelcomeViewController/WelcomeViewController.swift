//
//  WelcomeViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 27.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import MBProgressHUD

final class WelcomeViewController: UIViewController, NavigationBarStyled {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var ordersStackView: UIStackView!
    @IBOutlet fileprivate weak var stackViewHeightConstr: NSLayoutConstraint!
    @IBOutlet fileprivate weak var receiptStackView: UIStackView!
    
    @IBOutlet private weak var askLabel: UILabel!
    @IBOutlet private weak var diagnosticLabel: UILabel!
    @IBOutlet private weak var mapLabel: UILabel!
    
    @IBOutlet private var categorieLabels: [UILabel]!
    
    @IBOutlet private var categoriesViews: [UIView]!
    
    @IBOutlet private var buttonsBackground: [UIView]!
    
    @IBOutlet private weak var loadReceipeButton: UIButton!
    @IBOutlet private weak var watchCategoriesButton: UIButton!
    @IBOutlet private weak var categoriesLabel: UILabel!
    @IBOutlet private weak var watchRecentlyLabel: UILabel!
    
    var style: NavigationBarStyle = .largeSearch
    
    var model: WelcomeModelInput!
    
    private lazy var activityIndicator: MBProgressHUD = {
        let hud = MBProgressHUD(view: view)
        hud.contentColor = .gray
        hud.backgroundView.style = .solidColor
        hud.backgroundView.color = UIColor.black.withAlphaComponent(0.2)
        hud.removeFromSuperViewOnHide = false
        view.addSubview(hud)

        return hud
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.show(animated: true)
        setupUI()
        model.load()
    }
    
    // MARK: - Setup
    
    private func setupLocalization() {
        
        scrollView.horizontalScrollIndicatorInsets = .zero
        scrollView.alwaysBounceHorizontal = false
        askLabel.text = R.string.localize.welcomeAsk()
        diagnosticLabel.text = R.string.localize.welcomeDiagnostic()
        mapLabel.text = R.string.localize.welcomeMap()
        
        loadReceipeButton.setTitle(R.string.localize.welcomeReceipe(), for: .normal)
        watchCategoriesButton.setTitle(R.string.localize.welcomeWatch_all(), for: .normal)
        categoriesLabel.text = R.string.localize.welcomeCategories()
        watchRecentlyLabel.text = R.string.localize.welcomeWatchRecently()
        
        subscribeScrollViewToKeyboard(scrollView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let nvc = navigationController,
            let navigationBar = nvc.navigationBar as? NavigationBar {
            navigationBar.title = R.string.localize.welcomeTitle()
            navigationBar.searchBar.searchBarHandler = {
                self.searchHandler()
            }
        }
    }
    
    private func setupUI() {
        setupLocalization()
        
        buttonsBackground.forEach({
            $0.layer.cornerRadius = 10
            $0.dropBlueShadow()
        })
        
        loadReceipeButton.dropBlueShadow()
        loadReceipeButton.layer.cornerRadius = loadReceipeButton.frame.height / 2
        
        for (index, item) in categoriesViews.enumerated() {
            item.tag = index
            let tap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped(_:)))
            item.addGestureRecognizer(tap)
        }
    }
    
    @objc func categoryTapped(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else {return}
        model.openCategories(index)
    }
    
    // MARK: Actions
    
    @IBAction private func selectCategory(_ sender: UIButton) {
        model.openCategories(nil)
    }
    
    private func searchHandler() {
        model.openSearchScreen()
    }
}

extension WelcomeViewController: WelcomeModelOutput {
    func modelIsLoaded() {
        for index in 0...categorieLabels.count-1 {
            categorieLabels[index].text = model.categories[index].shortTitle
        }
        activityIndicator.hide(animated: true)
    }
    
    func showReadyOrders(orders: [String]) {
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
    
    func showReceipts(_ receipts: [Receipt]) {
        receiptStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        
        for receipt in receipts {
            if let receiptView: ReceiptView  = R.nib.receiptView(owner: self) {
                receiptView.apply(receipt: receipt)
                receiptStackView.addArrangedSubview(receiptView)
            }
        }
    }
}
