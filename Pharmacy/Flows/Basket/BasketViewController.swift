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
        let hud = MBProgressHUD(view: view)
        hud.contentColor = .gray
        hud.backgroundView.style = .solidColor
        hud.backgroundView.color = UIColor.black.withAlphaComponent(0.2)
        hud.removeFromSuperViewOnHide = false
        view.addSubview(hud)

        return hud
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(
            UINib(nibName: "CartSectionHeader", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "CartSectionHeader")

        tableView.register(
            UINib(nibName: "CartSectionFooterView", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "CartSectionFooterView")

        tableView.isHidden = true
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
        return model.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "CartMedecineCell", for: indexPath) as? CartMedecineCell else {
            return UITableViewCell()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: "CartSectionHeader") as? CartSectionHeader else {
            return nil
        }

        view.apply()

        return view
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: "CartSectionFooterView") as? CartSectionFooterView else {
            return nil
        }
        return view
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return model.numberOfSections
    }
}

// MARK: - BasketViewControllerInput

extension BasketViewController: BasketViewControllerInput {

    func cartDidLoad() {
        tableView.isHidden = false
        activityIndicator.hide(animated: true)
        tableView.reloadData()
    }

}
