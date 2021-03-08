//
//  ClinicTableCell.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 22.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

enum ClinicTableCellEvent {
    
}

class ClinicTableCell: BaseCell<ClinicModel, ClinicTableCellEvent> {
    
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var mapButton: UIButton!
    @IBOutlet private weak var orderServiceButton: UIButton!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var orderedView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 13
        orderServiceButton.layer.cornerRadius = 12
    }
    
    func apply(model: ClinicModel) {
        self.logoImageView.image = UIImage(named: model.imageClinic ?? "logo_invitro")
        self.nameLabel.text = model.clinicName
        self.addressLabel.text = model.adressClinic
        self.phoneLabel.text = model.phoneNumber
        self.orderedView?.isHidden = !model.ordered
    }
    
    override func fill(with model: ClinicModel) {
        super.fill(with: model)
        apply(model: model)
    }
}
