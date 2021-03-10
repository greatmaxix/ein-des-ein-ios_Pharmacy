//
//  ClinicTableCell.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 22.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

enum ClinicTableCellEvent {
    case mapAction
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
    
    private var mapAction: () -> Void = { }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 13
        orderServiceButton.layer.cornerRadius = 12
        mapButton.addTarget(self, action: #selector(self.showOnMap), for: .touchUpInside)
    }
    
    func apply(model: ClinicModel, mapAction: @escaping () -> Void) {
        self.logoImageView.image = UIImage(named: model.imageClinic ?? "logo_invitro")
        self.nameLabel.text = model.clinicName
        self.addressLabel.text = model.adressClinic
        self.phoneLabel.text = model.phoneNumber
        self.orderedView?.isHidden = !model.ordered
        self.mapAction = mapAction
    }
    
    override func fill(with model: ClinicModel) {
        super.fill(with: model)
        apply(model: model, mapAction: { [weak self] in
            self?.eventHandler?(.mapAction)
        })
    }
    
    @objc private func showOnMap() {
        mapAction()
    }
}
