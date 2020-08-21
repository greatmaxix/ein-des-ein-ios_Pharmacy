//
//  WishlistViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 20.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class WishlistViewController: UIViewController {

    var model: WishlistInput!
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
        
        emptyView.setup(title: R.string.localize.wishlistEmptyTitle(), decriptionText: R.string.localize.wishlistEmptyDescription(), buttonTitle: R.string.localize.wishlistEmptyButton())
        
        emptyResultsView = emptyView
    }
    
    private func setupUI() {
        if let bar = navigationController?.navigationBar as? SimpleNavigationBar {
            
            bar.title = R.string.localize.wishlistEmptyBarTitle()
            bar.isLeftItemHidden = false
            bar.leftItemTitle = R.string.localize.profileTitle()
            bar.isRightItemHidden = true
            bar.barDelegate = self
        }
    }
}

extension WishlistViewController: SimpleNavigationBarDelegate {
    func leftBarItemAction() {
        model.close()
    }
    
    func rightBarItemAction() {
    }
}
