//
//  OrderListCell.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 02.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class OrderListCell: UITableViewCell {

    @IBOutlet weak var corneredView: UIView!
    @IBOutlet weak var orderStatusView: UIView!
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var deliveryTypeLabel: UILabel!
    @IBOutlet weak var deliveryTypeImageView: UIImageView!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var pharmacyLabel: UILabel!
    @IBOutlet weak var productsCountLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        corneredView.dropLightBlueShadow()
    }

    func apply(order: Order) {
        orderNumberLabel.text = "№ \(order.orderId ?? 0)"
        timestampLabel.text = order.orderCreatedAt
        pharmacyLabel.text = "\(order.pharmacy?.name ?? ""), \(order.pharmacy?.location ?? "")"
        productsCountLabel.text = "\(order.products?.count ?? 0) товар (ов)"
        totalCostLabel.text = order.totalCost?.moneyString(with: "₸")

        if order.deliveryInfo?.type == "pickup" {
            deliveryTypeLabel.text = "Самовывоз"
            deliveryTypeImageView.image = R.image.icon_selfdelivery()
            deliveryView.backgroundColor = R.color.pickup()
        } else {
            deliveryTypeLabel.text = "Доставка"
            deliveryTypeImageView.image = R.image.icon_delivery()
            deliveryView.backgroundColor = R.color.delivery()
        }

        let state = OrderListRequestState.init(rawValue: order.status ?? "new")

        switch state {
        case .new:
            orderStatusView.backgroundColor = R.color.welcomeBlue()
            orderStatusLabel.text = "НОВЫЙ"
        case .inProgress:
            orderStatusView.backgroundColor = R.color.orange()
            orderStatusLabel.text = "В ОБРАБОТКЕ"
        case .done:
            orderStatusView.backgroundColor = R.color.welcomeBlue()
            orderStatusLabel.text = "ВЫПОЛНЕН"
        case .canceled:
            orderStatusView.backgroundColor = R.color.validationRed()
            orderStatusLabel.text = "ОТМЕНЕН"
        default:
            orderStatusView.backgroundColor = R.color.welcomeGreen()
            orderStatusLabel.text = "В ОБРАБОТКЕ"
        }
    }
}
