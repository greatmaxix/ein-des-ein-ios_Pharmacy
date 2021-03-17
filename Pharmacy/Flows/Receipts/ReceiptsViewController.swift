//
//  ReceiptsViewController.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 12.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import MBProgressHUD
import PDFKit

protocol ReceiptsViewControllerInput: ReceiptsModelOutput {}
protocol ReceiptsViewControllerOutput: ReceiptsModelInput {}

class ReceiptsViewController: UIViewController, NavigationBarStyled {

    @IBOutlet var addReceptButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    var style: NavigationBarStyle = .normalWithoutSearch

    private lazy var activityIndicator: MBProgressHUD = {
        setupActivityIndicator()
    }()

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var pdfView: PDFView!

    var model: ReceiptsViewControllerOutput!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        tableView.register(UINib(nibName: "ReceiptCell", bundle: nil), forCellReuseIdentifier: "ReceiptCell")
        addReceptButton.layer.cornerRadius = 14
        title = "Рецепты"

        setupUI()

        tableView.isHidden = true
        emptyView.isHidden = true
    }
    


    @IBAction func addReceptButtonAction(_ sender: Any) {
        print("addReceptButtonAction")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        activityIndicator.show(animated: true)
        model.initialLoad()
        self.lolilization()
    }

    private func setupUI() {
        if let bar = self.navigationController?.navigationBar as? SimpleNavigationBar {
            bar.title = R.string.localize.prescriptionsEmptyBarTitle.localized()
            bar.isLeftItemHidden = false
            bar.leftItemTitle = nil
            bar.isRightItemHidden = true
            bar.barDelegate = self
            bar.style = .normalWithoutSearch
        } else if let bar = self.navigationController?.navigationBar as? NavigationBar {
            bar.smallNavBarTitleLabel.text = R.string.localize.prescriptionsEmptyBarTitle.localized()
        }
    }
    private func lolilization() {
        self.titleLabel.text = R.string.localize.prescriptionsEmptyTitle.localized()
        self.subTitleLabel.text = R.string.localize.prescriptionsEmptyDescription.localized()
        addReceptButton.setTitle(R.string.localize.recipient_cancel.localized(), for: .normal)
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

        if model.numberOfReceipts == 0 {
            emptyView.isHidden = false
        } else {
            tableView.isHidden = false
            tableView.reloadData()
        }
    }

    func startLoading() {
        activityIndicator.show(animated: true)
    }

    func openPDF(url: URL) {
        pdfView.isHidden = false
        if let pdfDocument = PDFDocument(url: url) {
            pdfView.displayMode = .singlePageContinuous
            pdfView.autoScales = true
            pdfView.displayDirection = .vertical
            pdfView.document = pdfDocument
        }
    }

    func pdfLoaded() {
        activityIndicator.hide(animated: true)
    }
    
}

extension ReceiptsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptCell", for: indexPath) as? ReceiptCell else {
            return UITableViewCell()
        }

        cell.apply(receipt: model.receipt(at: indexPath))

        cell.pdfHandler = { [weak self] in
            self?.model.downloadPDF(at: indexPath)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfReceipts
    }

}
