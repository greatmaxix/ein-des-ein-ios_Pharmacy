//
//  OrderDetailsViewController.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 02.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol OrderDetailsViewControllerInput: OrderDetailsModelOutput {}
protocol OrderDetailsViewControllerOutput: OrderDetailsModelInput {}

class OrderDetailsViewController: UIViewController {

    var model: OrderDetailsViewControllerOutput!

    private var isCanceled = false

    private lazy var activityIndicator: MBProgressHUD = {
        setupActivityIndicator()
    }()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var canceledOrderView: UIView!
    @IBOutlet weak var canceledOrderLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.show(animated: true)
        model.load()
        titleLabel.text = "№ \(model.currentOrderId)"

        canceledOrderLabel.text = "Ваш заказ № \(model.currentOrderId) отменен"
        canceledOrderView.isHidden = true

        tableView.register(UINib(nibName: "OrderedProductCell", bundle: nil), forCellReuseIdentifier: "OrderedProductCell")
    }

    @IBAction func back(_ sender: Any) {
        model.back()
    }
}

extension OrderDetailsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch model.type(at: indexPath) {
        case .contactInfo:
            return contactInfoCell(at: indexPath)
        case .pharmacy:
            return pharmCell(at: indexPath)
        case .deliveryAddress:
            return deliveryCell(at: indexPath)
        case .paymentType:
            return paymentCell(at: indexPath)
        case .product:
            return productCell(at: indexPath)
        case .comments:
            return commentCell(at: indexPath)
        case .total:
            return totalCell(at: indexPath)
        default:
            return UITableViewCell()
        }
    }

    private func contactInfoCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsContactCell", for: indexPath) as? OrderDetailsContactCell else { return UITableViewCell() }

        if let contact = model.contact {
            cell.apply(contact: contact)
        }

        return cell
    }

    private func totalCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsTotalCell", for: indexPath) as? OrderDetailsTotalCell else { return UITableViewCell() }

        cell.apply(cost: model.cost, isCanceled: isCanceled)
        cell.actionHandler = { [weak self] in
            self?.model.cancelOrder()
        }

        return cell
    }

    private func pharmCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsPharmacyCell", for: indexPath) as? OrderDetailsPharmacyCell else { return UITableViewCell() }

        if let pharmacy = model.pharmacy {
            cell.apply(pharm: pharmacy)
        }

        return cell
    }

    private func deliveryCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsDeliveryCell", for: indexPath) as? OrderDetailsDeliveryCell else { return UITableViewCell() }

        if let delivery = model.delivery {
            cell.apply(delivery: delivery)
        }

        return cell
    }

    private func paymentCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsPaymentCell", for: indexPath) as? OrderDetailsPaymentCell else { return UITableViewCell() }

        return cell
    }

    private func commentCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsCommentCell", for: indexPath) as? OrderDetailsCommentCell else { return UITableViewCell() }

        cell.apply(comment: model.comment)

        return cell
    }

    private func productCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderedProductCell", for: indexPath) as? OrderedProductCell else { return UITableViewCell() }

        if let product = model.product(at: indexPath) {
            cell.apply(product: product)
        }

        return cell
    }

}

extension OrderDetailsViewController: OrderDetailsViewControllerInput {

    func didLoadData(error: String?) {
        activityIndicator.hide(animated: true)

        if model.orderState == .canceled {
            canceledOrderView.isHidden = false
            isCanceled = true
        }

        if error != nil {
            showError(text: error!)
        }

        tableView.reloadData()
    }

}
