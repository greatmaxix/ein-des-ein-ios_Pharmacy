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

    @IBOutlet weak var emptyView: UIView!
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

    @IBAction func startSearch(_ sender: Any) {
        model.startSearch()
    }
}

// MARK: - TableView

extension BasketViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
        return model.numberOfSections
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

        if model.numberOfOrders == 0 {
            emptyView.isHidden = false
            tableView.isHidden = true
        } else {
            emptyView.isHidden = true
            tableView.isHidden = false
        }
    }

    func requestCompleted() {
        activityIndicator.hide(animated: true)
        tableView.reloadData()
    }

    func cartDidLoad() {
        if model.numberOfOrders == 0 {
            emptyView.isHidden = false
            tableView.isHidden = true
        } else {
            emptyView.isHidden = true
            tableView.isHidden = false
        }
        activityIndicator.hide(animated: true)
        tableView.reloadData()
    }

}
