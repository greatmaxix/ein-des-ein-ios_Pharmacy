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

        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HH:mm dd:MM.YY"

        if let date = dateFormatterGet.date(from: order.orderCreatedAt ?? "") {
            timestampLabel.text = dateFormatterPrint.string(from: date)
        } else {
            timestampLabel.text = order.orderCreatedAt
        }
        
        pharmacyLabel.text = "\(order.pharmacy?.name ?? ""), \(order.pharmacy?.location ?? "")"
        productsCountLabel.text = "\(order.products?.count ?? 0) товар (ов)"
        totalCostLabel.text = order.totalCost?.moneyString(with: "₸")

        if order.deliveryInfo?.type == "pickup" {
            deliveryTypeLabel.text = R.string.localize.order_delivary_own.localized()
            deliveryTypeLabel.textColor = R.color.textDarkBlue()
            deliveryTypeImageView.image = R.image.icon_selfdelivery()
            deliveryTypeImageView.tintColor = R.color.textDarkBlue()
            deliveryView.backgroundColor = R.color.pickup()
        } else {
            deliveryTypeLabel.text = R.string.localize.order_delivary.localized()
            deliveryTypeLabel.textColor = R.color.textDarkBlue()
            deliveryTypeImageView.image = R.image.icon_delivery()
            deliveryTypeImageView.tintColor = R.color.textDarkBlue()
            deliveryView.backgroundColor = R.color.delivery()
            
        }

        let state = OrderListRequestState.init(rawValue: order.status ?? "new")

            switch state {
            case .new:
                orderStatusView.backgroundColor = R.color.welcomeBlue()
                orderStatusLabel.text = R.string.localize.order_new.localized()
            case .inProgress:
                orderStatusView.backgroundColor = R.color.orange()
                orderStatusLabel.text = R.string.localize.order_delivary.localized()
            case .done:
                orderStatusView.backgroundColor = R.color.welcomeBlue()
                orderStatusLabel.text = R.string.localize.order_done.localized()
            case .canceled:
                orderStatusView.backgroundColor = R.color.validationRed()
                orderStatusLabel.text = R.string.localize.order_cancel.localized()
            default:
                orderStatusView.backgroundColor = R.color.welcomeGreen()
                orderStatusLabel.text = R.string.localize.order_delivary.localized()
            }
    }

}
