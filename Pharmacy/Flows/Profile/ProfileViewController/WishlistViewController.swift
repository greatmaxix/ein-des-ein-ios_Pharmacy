//
//  WishlistViewController.swift
//  Pharmacy
//
//  Created by Mishko on 20.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class WishlistViewController: UIViewController, ActivityIndicatorDelegate {

    @IBOutlet private weak var tableView: UITableView!
    private var indicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var model: WishlistInput!
    private var emptyResultsView: EmptyResultsView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        applyEmptyStyle()
        model.load()
        setupUI()
        showActivityIndicator(activityIndicator: indicator)
    }

    private func applyEmptyStyle() {
        
        let emptyView: EmptyResultsView = EmptyResultsView.fromNib()
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.isHidden = true
        view.addSubview(emptyView)
        emptyView.constraintsToSuperView()
        
        emptyView.setup(title: R.string.localize.wishlistEmptyTitle(), decriptionText: R.string.localize.wishlistEmptyDescription(), buttonTitle: R.string.localize.wishlistEmptyButton())
        
        emptyResultsView = emptyView
    }
    
    private func setupUI() {
        
        tableView.delegate = self
        
        if let bar = navigationController?.navigationBar as? SimpleNavigationBar {
            
            bar.title = R.string.localize.wishlistEmptyBarTitle()
            bar.isLeftItemHidden = false
            bar.leftItemTitle = nil
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

extension WishlistViewController: WishlistOutput {
    
    func showDeletionError() {
        showError(message: "Unable to remove medicine from wishlist")
    }
    
    func didLoadList() {
        
        emptyResultsView?.isHidden = !model.wishlistIsEmpty
        hideActivityIndicator(activityIndicator: indicator)
        model.dataSource.assign(tableView: tableView)
        tableView.reloadData()
    }
}

extension WishlistViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        model.loadNextPages(lastMedicineIndex: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
