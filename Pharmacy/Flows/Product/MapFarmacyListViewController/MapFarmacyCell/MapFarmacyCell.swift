//
//  SelectFarmacyCell.swift
//  Pharmacy
//
//  Created by CGI-Kite on 25.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class MapFarmacyCell: UITableViewCell {

    @IBOutlet weak var cellBackgroundView: UIView!
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
    
    var addToPurchesesHandler: EmptyClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        selectButton.layer.cornerRadius = selectButton.bounds.height / 2
        cellBackgroundView.layer.cornerRadius = 8
        selectButton.setTitle(R.string.localize.farmaciesListAddToBag(), for: .normal)
    }
    
    private func addMedicines(medicines: [PharmacyModel.SimpleMedicine]) {
        
        medicineStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        for medicine in medicines {
            let medicineView: FoundMedicineView = FoundMedicineView.fromNib()
            medicineView.titleLabel.text = "medicine"
            medicineView.priceLabel.text = "\(medicine.price) $"
            medicineStackView.addArrangedSubview(medicineView)
        }
    }

    func apply(pharmacy: PharmacyModel) {
        nameLabel.text = pharmacy.name
        phoneLabel.text = Const.phoneTitle + (pharmacy.phone ?? Const.phoneErrorTitle)
        addressLabel.text = pharmacy.geometry.address
        medicineStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        addMedicines(medicines: pharmacy.medicines)
    }
    
    @IBAction func openMap(_ sender: UIButton) {
    }
    
    @IBAction func selectFarmacy(_ sender: UIButton) {
        self.addToPurchesesHandler?()
    }    
}

fileprivate extension MapFarmacyCell {
    
    struct Const {
        static let phoneTitle: String = "📞️ "
        static let phoneErrorTitle: String = "phone is not availible"
    }
}
