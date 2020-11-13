//
//  ReceiptsViewController.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 12.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol ReceiptsViewControllerInput: ReceiptsModelOutput {}
protocol ReceiptsViewControllerOutput: ReceiptsModelInput {}

class ReceiptsViewController: UIViewController, NavigationBarStyled {

    var style: NavigationBarStyle = .normalWithoutSearch

    private lazy var activityIndicator: MBProgressHUD = {
        setupActivityIndicator()
    }()

    @IBOutlet private weak var tableView: UITableView!

    var model: ReceiptsViewControllerOutput!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        tableView.register(UINib(nibName: "ReceiptCell", bundle: nil), forCellReuseIdentifier: "ReceiptCell")
        title = "Рецепты"

        setupUI()
        tableView.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        activityIndicator.show(animated: true)
        model.initialLoad()
    }

    private func setupUI() {
        if let bar = navigationController?.navigationBar as? SimpleNavigationBar {

            bar.title = "Рецепты"
            bar.isLeftItemHidden = false
            bar.leftItemTitle = nil
            bar.isRightItemHidden = true
            bar.barDelegate = self
        }
    }

}

extension ReceiptsViewController: SimpleNavigationBarDelegate {
    func leftBarItemAction() {
        model.close()
    }

    func rightBarItemAction() {
    }
}

extension ReceiptsViewController: ReceiptsViewControllerInput {

    func complete(isEmpty: Bool, error: String?) {
        activityIndicator.hide(animated: true)

        if error != nil {
            showError(text: error!)
        }

        tableView.isHidden = false
        tableView.reloadData()
    }

    func startLoading() {

    }
    
}

extension ReceiptsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptCell", for: indexPath) as? ReceiptCell else {
            return UITableViewCell()
        }

        cell.apply(receipt: model.receipt(at: indexPath))

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfReceipts
    }

}
