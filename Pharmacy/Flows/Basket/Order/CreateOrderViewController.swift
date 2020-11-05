//
//  CreateOrderViewController.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 29.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol CreateOrderViewControllerInput: CreateOrderModelOutput {}
protocol CreateOrderViewControllerOutput: CreateOrderModelInput {}

class CreateOrderViewController: UIViewController {

    var model: CreateOrderViewControllerOutput!

    private lazy var activityIndicator: MBProgressHUD = {
        setupActivityIndicator()
    }()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "CreateOrderContactInfoCell", bundle: nil), forCellReuseIdentifier: "CreateOrderContactInfoCell")

        tableView.register(UINib(nibName: "OrderDeliveryCell", bundle: nil), forCellReuseIdentifier: "OrderDeliveryCell")

        tableView.register(UINib(nibName: "OrderPharmacyCell", bundle: nil), forCellReuseIdentifier: "OrderPharmacyCell")

        tableView.register(UINib(nibName: "DeliveryAddressCell", bundle: nil), forCellReuseIdentifier: "DeliveryAddressCell")

        tableView.register(UINib(nibName: "PaymentTypeCell", bundle: nil), forCellReuseIdentifier: "PaymentTypeCell")

        tableView.register(UINib(nibName: "OrderedProductCell", bundle: nil), forCellReuseIdentifier: "OrderedProductCell")

        tableView.register(UINib(nibName: "OrderCommentCell", bundle: nil), forCellReuseIdentifier: "OrderCommentCell")

        tableView.register(UINib(nibName: "OrderSummaryCell", bundle: nil), forCellReuseIdentifier: "OrderSummaryCell")
    }

    @IBAction func back(_ sender: Any) {
        model.back()
    }

}

extension CreateOrderViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch model.type(at: indexPath) {
        case .contactInfo:
            return contactInfoCell(at: indexPath)
        case .delivery:
            return deliveryTypeCell(at: indexPath)
        case .pharmacy:
            return pharmacyCell(at: indexPath)
        case .deliveryAddress:
            return deliveryAddress(at: indexPath)
        case .paymentType:
            return paymentSelectionCell(at: indexPath)
        case .product:
            return productCell(at: indexPath)
        case .comments:
            return commentCell(at: indexPath)
        case .total:
            return totalInfoCell(at: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfRows
    }

    private func contactInfoCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CreateOrderContactInfoCell", for: indexPath) as? CreateOrderContactInfoCell else { return UITableViewCell() }

        if let contact = model.contact {
            cell.apply(contact: contact)
        }

        return cell
    }

    private func pharmacyCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPharmacyCell", for: indexPath) as? OrderPharmacyCell else { return UITableViewCell() }

        cell.apply(order: model.currentOrder)

        return cell
    }

    private func totalInfoCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryCell", for: indexPath) as? OrderSummaryCell else { return UITableViewCell() }

        cell.apply(order: model.currentOrder, valid: true)

        cell.confirmAction = { [weak self] in
            self?.activityIndicator.show(animated: true)
            self?.model.createOrder()
        }

        return cell
    }

    private func deliveryAddress(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryAddressCell", for: indexPath) as? DeliveryAddressCell else { return UITableViewCell() }

        if let address = model.address {
            cell.apply(delivery: address)
        }

        return cell
    }

    private func commentCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCommentCell", for: indexPath) as? OrderCommentCell else { return UITableViewCell() }

        cell.delegate = self

        return cell
    }

    private func productCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderedProductCell", for: indexPath) as? OrderedProductCell else { return UITableViewCell() }

        cell.apply(product: model.product(at: indexPath))

        return cell
    }

    private func deliveryTypeCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDeliveryCell", for: indexPath) as? OrderDeliveryCell else { return UITableViewCell() }

        cell.deliveryHandle = { [weak self] in
            self?.model.changeDelivery(type: .ordered)
        }

        cell.selfHandler = { [weak self] in
            self?.model.changeDelivery(type: .selfdelivery)
        }

        cell.apply()

        return cell
    }

    private func paymentSelectionCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTypeCell", for: indexPath) as? PaymentTypeCell else { return UITableViewCell() }

        cell.apply()

        return cell
    }
    
}

extension CreateOrderViewController: CreateOrderViewControllerInput {

    func networkEnded(with error: String?) {
        activityIndicator.hide(animated: true)
        if error != nil {
            showError(text: error!)
        }
    }

    func reload() {

    }
    
    func setAddress(hidden: Bool, at index: Int) {
        if hidden == true {
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        } else {
            tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }

}

extension CreateOrderViewController: CommentCellProtocol {

    func valueChanged(comment: String) {
        model.update(comment: comment)
    }

}
