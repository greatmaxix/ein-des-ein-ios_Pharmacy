//
//  OrdersViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 20.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol OrdersViewControllerInput: OrdersListOutput {}
protocol OrdersViewControllerOutput: OrdersListInput {}

final class OrdersViewController: UIViewController {

    var model: OrdersViewControllerOutput!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var inProgressButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelledButton: UIButton!

    @IBOutlet var controllButtons: [UIButton]!

    private lazy var activityIndicator: MBProgressHUD = {
        let hud = MBProgressHUD(view: view)
        hud.contentColor = .gray
        hud.backgroundView.style = .solidColor
        hud.backgroundView.color = UIColor.black.withAlphaComponent(0.2)
        hud.removeFromSuperViewOnHide = false
        view.addSubview(hud)

        return hud
    }()

    private var emptyResultsView: EmptyResultsView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        model.initialLoad()
        allButton.dropBlueShadow()
    }

    private func applyEmptyStyle() {
        
        let emptyView: EmptyResultsView = EmptyResultsView.fromNib()
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyView)
        emptyView.constraintsToSuperView()
        
        emptyView.setup(title: R.string.localize.myOrdersEmptyTitle(), decriptionText: R.string.localize.myOrdersEmptyDescription(), buttonTitle: R.string.localize.myOrdersEmptyButton())
        
        emptyResultsView = emptyView
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

    @IBAction func openInProgress(_ sender: Any) {
        model.open(tab: .processing)
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
        if isEmpty == true {
//            applyEmptyStyle()
        }

        tableView.reloadData()

        activityIndicator.hide(animated: true)
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

extension OrdersViewController: SimpleNavigationBarDelegate {
    func leftBarItemAction() {
        model.close()
    }
    
    func rightBarItemAction() {
    }

    func startLoading() {
        activityIndicator.show(animated: true)
    }
}
