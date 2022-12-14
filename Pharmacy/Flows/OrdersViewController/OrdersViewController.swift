//
//  OrdersViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 20.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol OrdersViewControllerInput: OrdersListOutput {}
protocol OrdersViewControllerOutput: OrdersListInput {}

final class OrdersViewController: UIViewController {

    var model: OrdersViewControllerOutput!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var inProgressButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelledButton: UIButton!
    @IBOutlet weak var emptyView: UIView!

    @IBOutlet var navBarTitle: UILabel!
    @IBOutlet var controllButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        allButton.dropBlueShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarTitle.text = R.string.localize.order_title.localized()
    }
    
    private func setupTableView() {
        tableView.isHidden = true
        emptyView.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        model.initialLoad()
    }

    @IBAction func back(_ sender: Any) {
        model.close()
    }

    @IBAction func openAll(_ sender: Any) {
        model.open(tab: .all)
        setActive(button: allButton)
    }

    @IBAction func openDone(_ sender: Any) {
        model.open(tab: .done)
        setActive(button: doneButton)
    }

    @IBAction func openCart(_ sender: Any) {
        model.startSearch()
    }

    @IBAction func openInProgress(_ sender: Any) {
        model.open(tab: .inProgress)
        setActive(button: inProgressButton)
    }
    
    @IBAction func openCanceled(_ sender: Any) {
        model.open(tab: .canceled)
        setActive(button: cancelledButton)
    }

    private func setAllInactive() {
        for button in controllButtons {
            button.setTitleColor(R.color.gray(), for: .normal)
            button.backgroundColor = .clear
            button.removeShadow()
        }
    }

    private func setActive(button: UIButton) {
        setAllInactive()
        
        button.setTitleColor(R.color.welcomeBlue(), for: .normal)
        button.backgroundColor = .white
        button.dropBlueShadow()
    }
}

extension OrdersViewController: OrdersViewControllerInput {
    func complete(isEmpty: Bool, error: String?) {
        PulseLoaderService.hide(from: view)

        if error != nil {
            showError(text: error!)
        }

        if model.numberOfOrders == 0 {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }

    func startLoading() {
        PulseLoaderService.showAdded(to: view)
    }
}

extension OrdersViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfOrders
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListCell", for: indexPath) as? OrderListCell else { return UITableViewCell() }

        cell.apply(order: model.order(at: indexPath))

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        model.open(at: indexPath)
    }

}
