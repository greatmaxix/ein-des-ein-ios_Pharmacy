//
//  BasketViewController.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 07.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol BasketViewControllerInput: BasketModelOutput {}
protocol BasketViewControllerOutput: BasketModelInput {}

final class BasketViewController: UIViewController {
    var model: BasketViewControllerOutput!

    @IBOutlet weak var tableView: UITableView!

    private lazy var activityIndicator: MBProgressHUD = {
        setupActivityIndicator()
    }()
    
    private var emptyResultsView: EmptyResultsView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.isHidden = true
        
        tableView.register(
            UINib(nibName: "CartSectionHeader", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "CartSectionHeader")

        tableView.register(
            UINib(nibName: "CartSectionFooterView", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "CartSectionFooterView")

        tableView.register(
            UINib(nibName: "EmptyResultsViewCell", bundle: nil),
            forCellReuseIdentifier: "EmptyResultsViewCell")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        activityIndicator.show(animated: true)
        
        model.load()
    }

}

// MARK: - TableView

extension BasketViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (model.numberOfOrders == 0) ? 1 : model.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if model.numberOfOrders == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyResultsViewCell", for: indexPath) as? EmptyResultsViewCell else { return UITableViewCell() }

            cell.setup(title: R.string.localize.basketEmptyTitle(),
                       decriptionText: R.string.localize.basketEmptyDescription(),
                       buttonTitle: R.string.localize.basketEmptyButton(),
                       imageName: "emptyOrders")

            cell.tapCellButtonHandler = {[weak self] in
                self?.model.startSearch()
            }

            return cell
        }

        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "CartMedecineCell", for: indexPath) as? CartMedecineCell else {
            return UITableViewCell()
        }

        cell.apply(medecine: model.medecine(at: indexPath))

        cell.increaseHandler = { [weak self] in
            self?.model.increaseCount(at: indexPath)
        }

        cell.decreaseHandler = { [weak self] in
            self?.model.decreaseCount(at: indexPath)
        }

        cell.deleteHandler = { [weak self] in
            self?.activityIndicator.show(animated: true)
            self?.model.deleteProduct(at: indexPath)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if model.numberOfOrders == 0 {
            return tableView.visibleSize.height
        } else {
            return tableView.estimatedRowHeight
        }

    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if model.numberOfOrders == 0 { return nil }

        guard let view = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: "CartSectionHeader") as? CartSectionHeader else {
            return nil
        }

        view.apply(order: model.section(at: section))
        view.closureActionHandler = { [weak self] in
            self?.model.sectionClosureChanged(at: section)
        }

        return view
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if model.numberOfOrders == 0 { return nil }

        guard let view = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: "CartSectionFooterView") as? CartSectionFooterView else {
            return nil
        }

        view.apply(order: model.section(at: section))

        view.createOrderHandler = { [weak self] in
            self?.model.createOrder(at: section)
        }

        return view
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return (model.numberOfOrders == 0) ? 1 : model.numberOfSections
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - BasketViewControllerInput

extension BasketViewController: BasketViewControllerInput {

    func reloadSection(at index: Int, animated: Bool) {
        tableView.reloadSections(IndexSet(integer: index), with: (animated) ? .automatic : .none)
    }

    func reloadObject(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    func deleteProduct(at indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }

    func deleteOrder(at indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
        tableView.endUpdates()
    }

    func requestCompleted() {
        activityIndicator.hide(animated: true)
        tableView.reloadData()
    }

    func cartDidLoad() {
        tableView.isHidden = false
        activityIndicator.hide(animated: true)
        tableView.reloadData()
    }

}
