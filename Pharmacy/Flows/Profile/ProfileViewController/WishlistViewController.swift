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
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var model: WishlistInput!
    private var emptyResultsView: EmptyResultsView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        applyEmptyStyle()
        model.load()
        setupUI()

        setupActivityIndicator()
        showActivityIndicator()
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
    
// MARK: - setup Table view
    private func setupTableView(){
        tableView.register(UINib(resource: R.nib.medicineCell), forCellReuseIdentifier: String(describing: MedicineCell.self))
        tableView.dataSource = self
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
    
    func deleteFarovireRow(index: IndexPath) {
        tableView.deleteRows(at: [index], with: .fade)
        hideActivityIndicator()
    }
    
    func showDeletionError() {
        showError(message: "Unable to remove medicine from wishlist")
    }
    
    func didLoadList() {
        emptyResultsView?.isHidden = !model.wishlistIsEmpty
        hideActivityIndicator()
        tableView.reloadData()
    }
}

extension WishlistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.favoriteMedicine.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MedicineCell.self)) as? MedicineCell else {return UITableViewCell()}
        
        cell.apply(medicine: model.favoriteMedicine[indexPath.row])
        
        cell.favoriteButtonHandler = {[weak self] state in
            guard let self = self else {return}
            self.showActivityIndicator()
            self.model.deleteMedicine(id: self.model.favoriteMedicine[indexPath.row].id, index: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            model.selectMedicineAt(index: indexPath.row)
    }
    
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
