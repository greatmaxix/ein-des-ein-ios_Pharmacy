//
//  MapMessageView.swift
//  Pharmacy
//
//  Created by CGI-Kite on 27.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class MapMessageView: UIView {

    @IBOutlet private weak var swipeView: UIView!
    
    @IBOutlet private weak var presenceLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet weak private var addressLabel: UILabel!
    @IBOutlet weak private var phoneLabel: UILabel!
    @IBOutlet weak private var workTimeLabel: UILabel!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var medicineCountLabel: UILabel!
    @IBOutlet weak var medicineStackView: UIStackView!
    
    @IBOutlet weak var noMedicineTopSpace: NSLayoutConstraint!
    @IBOutlet weak var nonEmptyMedicineTopSpace: NSLayoutConstraint!
    
    override func awakeFromNib() {
        swipeView.layer.cornerRadius = swipeView.bounds.height / 2

        setupUI()
    }
    
    private func setupUI() {
        presenceLabel.text = "\(bounds.height)"
        selectButton.layer.cornerRadius = selectButton.bounds.height / 2
        selectButton.setTitle(R.string.localize.farmaciesListFarmacySelect(), for: .normal)
    }
    
    func addMedicines(titles: [String]) {
        for title in titles {
            let v: FoundMedicineView = FoundMedicineView.fromNib()
            v.titleLabel.text = title
            medicineStackView.addArrangedSubview(v)
        }
    }

    func apply(title: String) {
        nameLabel.text = title
        medicineStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        addMedicines(titles: ["medicine1", "medicine2"])
    }
    
    @IBAction func openMap(_ sender: UIButton) {
    }
    
    @IBAction func selectFarmacy(_ sender: UIButton) {
    }

}
