//
//  ClinicTableCell.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 22.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

enum ClinicTableCellEvent {
    case mapAction(ClinicModel)
    case orderAction(ClinicModel)
    case clinicInfo(ClinicModel)
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
    @IBOutlet private weak var clinicInfoButton: UIButton!
    
    private var mapAction: () -> Void = { }
    private var orderAction: () -> Void = { }
    private var clinicInfoAction: () -> Void = { }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 13
        orderServiceButton.layer.cornerRadius = 12
        mapButton.addTarget(self, action: #selector(self.showOnMap), for: .touchUpInside)
        orderServiceButton.addTarget(self, action: #selector(self.showOrder), for: .touchUpInside)
        clinicInfoButton.addTarget(self, action: #selector(self.showClinicInfoAction), for: .touchUpInside)
    }
    
    func apply(
        model: ClinicModel,
        mapAction: @escaping () -> Void,
        orderAction: @escaping () -> Void,
        clinicInfoAction: @escaping () -> Void
    ) {
        self.logoImageView.image = UIImage(named: model.imageClinic ?? "logo_invitro")
        self.nameLabel.text = model.clinicName
        self.addressLabel.text = model.adressClinic
        self.phoneLabel.text = model.phoneNumber
        self.orderedView?.isHidden = !model.ordered
        self.mapAction = mapAction
        self.orderAction = orderAction
        self.clinicInfoAction = clinicInfoAction
    }
    
    override func fill(with model: ClinicModel) {
        super.fill(with: model)
        apply(model: model, mapAction: { [weak self] in
            self?.eventHandler?(.mapAction(model))
        }, orderAction: { [weak self] in
            self?.eventHandler?(.orderAction(model))
        }, clinicInfoAction: { [weak self] in
            self?.eventHandler?(.clinicInfo(model))
        })
    }
    
    @objc private func showOnMap() {
        mapAction()
    }
    
    @objc private func showOrder() {
        orderAction()
    }
    
    @objc private func showClinicInfoAction() {
        clinicInfoAction()
    }
}
