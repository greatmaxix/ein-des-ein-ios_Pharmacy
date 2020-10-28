//
//  MedicineListViewController.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 12.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol MedicineListViewControllerInput: MedicineListModelOutput {}
protocol MedicineListViewControllerOutput: MedicineListModelInput {}

final class MedicineListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var productCountLabel: UILabel!
    @IBOutlet private weak var sortButton: UIButton!
    
    // MARK: - Properties
    var model: MedicineListViewControllerOutput!
    
    private lazy var activityIndicator: MBProgressHUD = {
        let hud = MBProgressHUD(view: view)
        hud.backgroundView.style = .solidColor
        hud.backgroundView.color = UIColor.black.withAlphaComponent(0.2)
        hud.removeFromSuperViewOnHide = false
        view.addSubview(hud)
        
        return hud
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.show(animated: true)
        model.load()
    }
}

// MARK: - Actions
extension MedicineListViewController {
    
    @IBAction func sortAction(_ sender: UIButton) {
        model.openFilter()
    }
}

// MARK: - Private
extension MedicineListViewController {
    
    private func configUI() {
        title = model.title
        sortButton.setTitle(R.string.localize.medicineSort(), for: .normal)
        sortButton.setTrailingImageViewWith(padding: GUI.sortButtonImagePadding)
    }
    
    private func setupTableView() {
        tableView.separatorInset = GUI.separatorInset
        tableView.separatorColor = GUI.separatorColor
        tableView.backgroundColor = R.color.lightGray()
        tableView.register(cellType: MedicineCell.self)
    }
}

// MARK: - FarmacyListViewControllerInput
extension MedicineListViewController: MedicineListViewControllerInput {
    
    func retrivesNewResults() {
        productCountLabel.attributedText = titleAttributed(count: model.totalNumberOfItems)
        activityIndicator.hide(animated: true)
        tableView.reloadData()
    }
    
    func retreivingMoreMedicinesDidEnd() {
        activityIndicator.hide(animated: true)
    }
    
    func needToInsertNewMedicines(at indexPathes: [IndexPath]?) {
        guard let indexPathes = indexPathes else {
            tableView.isHidden = false
            tableView.reloadData()
            
            return
        }

        tableView.beginUpdates()
        tableView.insertRows(at: indexPathes,
                             with: .automatic)
        tableView.endUpdates()
    }
}

// MARK: - UITableViewDataSource
extension MedicineListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.medicines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(at: indexPath, cellType: MedicineCell.self)
        cell.apply(medicine: model.medicines[indexPath.row])
        
        if model.isEndOfList == false && indexPath.row == model.medicines.count - 1 {
            activityIndicator.show(animated: true)
            model.retreiveMoreMedecines()
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MedicineListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        model.didSelectProductBy(indexPath: indexPath)
    }
}

// MARK: - Multiple attributes string

extension MedicineListViewController {
    
    fileprivate func titleAttributed(count: Int) -> NSAttributedString {
        let foundText = R.string.localize.medicineFound()
        let countText = "\(count)"
        let productText = count == 1 ?  R.string.localize.medicineFoundProduct() : R.string.localize.medicineFoundProducts()
        let text = "\(foundText) \(countText) \(productText)"
        
        let countFont = R.font.openSansBold(size: 16)!
        let font =  R.font.openSansRegular(size: 14)!
        let color = R.color.textDarkBlue()!
        
        let att = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: font, .foregroundColor: color])
        att.addAttribute(.font, value: countFont, range: NSRange(location: foundText.count + 1, length: countText.count))
        
        return att
    }
}

// MARK: - External declaration
extension MedicineListViewController {
    
    enum GUI {
        static let sortButtonImagePadding: CGFloat = 9
        static let separatorInset = UIEdgeInsets.only(left: 135)
        static let separatorColor = R.color.applyBlueGray()?.withAlphaComponent(0.2)
    }
}
