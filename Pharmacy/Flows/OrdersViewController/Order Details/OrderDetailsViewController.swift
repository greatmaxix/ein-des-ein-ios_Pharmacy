//
//  OrderDetailsViewController.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 02.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol OrderDetailsViewControllerInput: OrderDetailsModelOutput {}
protocol OrderDetailsViewControllerOutput: OrderDetailsModelInput {}

class OrderDetailsViewController: UIViewController {

    var model: OrderDetailsViewControllerOutput!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        model.load()
        titleLabel.text = "№ \(model.currentOrderId)"
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

    private func pharmCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsPharmacyCell", for: indexPath) as? OrderDetailsPharmacyCell else { return UITableViewCell() }

        if let pharmacy = model.pharmacy {
            cell.apply(pharm: pharmacy)
        }

        return cell
    }

}

extension OrderDetailsViewController: OrderDetailsViewControllerInput {

    func didLoadData(error: String?) {
        tableView.reloadData()
    }

}
