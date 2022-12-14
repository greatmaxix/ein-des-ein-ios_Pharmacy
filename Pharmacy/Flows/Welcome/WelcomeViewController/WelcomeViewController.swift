//
//  WelcomeViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 27.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.load()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let nvc = navigationController,
            let navigationBar = nvc.navigationBar as? NavigationBar {
            navigationBar.title = R.string.localize.welcomeTitle.localized()
            navigationBar.searchBar.searchBarHandler = { [weak self] in
                self?.searchHandler()
                
                return false
            }
        }
        setupUI()
        PulseLoaderService.showAdded(to: view)
        model.load()
        self.reloadInputViews()
    }
    
    // MARK: - Setup
    
    private func setupLocalization() {
        scrollView.horizontalScrollIndicatorInsets = .zero
        scrollView.alwaysBounceHorizontal = false
        askLabel.text = R.string.localize.welcomeAsk.localized()
        diagnosticLabel.text = R.string.localize.welcomeDiagnostic.localized()
        mapLabel.text = R.string.localize.welcomeMap.localized()
        
        loadReceipeButton.setTitle(R.string.localize.welcomeReceipe.localized(), for: .normal)
        watchCategoriesButton.setTitle(R.string.localize.welcomeWatch_all.localized(), for: .normal)
        categoriesLabel.text = R.string.localize.welcomeCategories.localized()
        watchRecentlyLabel.text = R.string.localize.welcomeWatchRecently.localized()
        
        subscribeScrollViewToKeyboard(scrollView)
    }
    
    private func setupUI() {
        setupLocalization()
        
        buttonsBackground.forEach({
            $0.layer.cornerRadius = 10
            $0.dropBlueShadow()
        })
        
        buttonsBackgroundImages.forEach({
//            $0.image = $0.image?.withRenderingMode(.alwaysOriginal)
        
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
    func loadingError() {
        PulseLoaderService.hide(from: view)
    }
    
    func modelIsLoaded() {
        for index in 0...categorieLabels.count-1 {
            categorieLabels[index].text = model.categories[index].shortTitle
            categorieImageView[index].kf.indicatorType = .activity
            categorieImageView[index].kf.setImage(with: model.categories[index].imageURL, options: [.processor(SVGImgProcessor())])
        }
        
        PulseLoaderService.hide(from: view)
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
