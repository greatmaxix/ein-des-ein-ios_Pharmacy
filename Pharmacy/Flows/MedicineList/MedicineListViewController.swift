//
//  MedicineListViewController.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 12.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol MedicineListViewControllerInput: MedicineListModelOutput {}
protocol MedicineListViewControllerOutput: MedicineListModelInput {}

final class MedicineListViewController: UIViewController {
    
    enum GUI {
        static let sortButtonImagePadding: CGFloat = 9
        static let separatorInset = UIEdgeInsets.only(left: 135)
        static let separatorColor = R.color.applyBlueGray()?.withAlphaComponent(0.2)
    }
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var productCountLabel: UILabel!
    @IBOutlet private weak var sortButton: UIButton!
    
    var model: MedicineListViewControllerOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        model.load()
    }
    
    // MARK: - Private
    
    private func configUI() {
        title = model.title
        tableView.separatorInset = GUI.separatorInset
        tableView.separatorColor = GUI.separatorColor
        tableView.delegate = self
        sortButton.setTitle(R.string.localize.medicineSort(), for: .normal)
        sortButton.setTrailingImageViewWith(padding: GUI.sortButtonImagePadding)
    }
    
    // MARK: - Actions
    
    @IBAction func sortAction(_ sender: UIButton) {
        
    }
}

// MARK: - FarmacyListViewControllerInput
extension MedicineListViewController: MedicineListViewControllerInput {

    func retrivesNewResults() {
        productCountLabel.attributedText = titleAttributed(count: model.totalNumberOfItems)
    }
    
    func retreivingMoreMedicinesDidEnd() {
        
    }
    
    func needToInsertNewMedicines(at: [IndexPath]?) {
        
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
