//
//  CreateOrderViewController.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 29.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol CreateOrderViewControllerInput: CreateOrderModelOutput {}
protocol CreateOrderViewControllerOutput: CreateOrderModelInput {}

class CreateOrderViewController: UIViewController {

    var model: CreateOrderViewControllerOutput!

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "CreateOrderContactInfoCell", bundle: nil), forCellReuseIdentifier: "CreateOrderContactInfoCell")

        tableView.register(UINib(nibName: "OrderDeliveryCell", bundle: nil), forCellReuseIdentifier: "OrderDeliveryCell")

        tableView.register(UINib(nibName: "OrderPharmacyCell", bundle: nil), forCellReuseIdentifier: "OrderPharmacyCell")

        tableView.register(UINib(nibName: "DeliveryAddressCell", bundle: nil), forCellReuseIdentifier: "DeliveryAddressCell")

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
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfRows
    }

    private func contactInfoCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CreateOrderContactInfoCell", for: indexPath) as? CreateOrderContactInfoCell else { return UITableViewCell() }

        return cell
    }

    private func pharmacyCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPharmacyCell", for: indexPath) as? OrderPharmacyCell else { return UITableViewCell() }

        cell.apply(order: model.currentOrder)

        return cell
    }

    private func deliveryAddress(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryAddressCell", for: indexPath) as? DeliveryAddressCell else { return UITableViewCell() }

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
    
}

extension CreateOrderViewController: CreateOrderViewControllerInput {

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
