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
    @IBOutlet private var categorieImageView: [UIImageView]!
    
    @IBOutlet private var categoriesViews: [UIView]!
    
    @IBOutlet private var buttonsBackground: [UIView]!
    @IBOutlet private var buttonsBackgroundImages: [UIImageView]!
    
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
        
        if let nvc = navigationController,
            let navigationBar = nvc.navigationBar as? NavigationBar {
            navigationBar.title = R.string.localize.welcomeTitle()
            navigationBar.searchBar.searchBarHandler = {
                self.searchHandler()
                return false
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        model.load()
        self.reloadInputViews()
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
    
    private func setupUI() {
        setupLocalization()
        
        buttonsBackground.forEach({
            $0.layer.cornerRadius = 10
            $0.dropBlueShadow()
        })
        
        buttonsBackgroundImages.forEach({
            $0.image = $0.image?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = $0.superview?.tintColor.withAlphaComponent(0.3)
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
    
    @objc func recentMedicineTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view as? ReceiptView else {return}
        model.openMedicineDetail(medicine: view.currentMedicineEntity)
    }
    
    // MARK: Actions
    
    @IBAction private func selectCategory(_ sender: UIButton) {
        model.openCategories(nil)
    }
    
    private func searchHandler() {
        model.openSearchScreen()
    }
    @IBAction func uploadReceipt(_ sender: Any) {
        model.openReceiptUpload()
    }

    @IBAction func chatTapped(_ sender: Any) {
        model.openChat()
    }

    @IBAction func diagnosisTapped(_ sender: Any) {
        model.openDiagnosis()
    }

    @IBAction func mapTapped(_ sender: Any) {
        model.openMap()
    }

}

extension WelcomeViewController: WelcomeModelOutput {
    func modelIsLoaded() {
        for index in 0...categorieLabels.count-1 {
            categorieLabels[index].text = model.categories[index].shortTitle
            categorieImageView[index].image = UIImage(named: model.categories[index].imageTitle)
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
    
    func showReceipts(_ receipts: [Medicine]) {
        receiptStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        
        for receipt in receipts {
            if let receiptView: ReceiptView  = R.nib.receiptView(owner: self) {
                receiptView.apply(receipt: receipt)
                
                receiptView.likeActionHandler = {[unowned self] state in
                    if state {
                        self.model.addToWishList(productId: receiptView.productId)
                    } else {
                        self.model.removeFromWishList(productId: receiptView.productId)
                    }
                }
                receiptView.addToChartHandler = {[unowned self] in
                    self.model.addToCart(productId: receiptView.productId)
                }
                receiptStackView.addArrangedSubview(receiptView)
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(recentMedicineTapped(_:)))
                receiptStackView.arrangedSubviews.forEach({$0.addGestureRecognizer(tap)})
            }
        }
    }
}
