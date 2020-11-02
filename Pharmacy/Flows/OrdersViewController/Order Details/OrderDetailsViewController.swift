//
//  OrderDetailsViewController.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 02.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol OrderDetailsViewControllerInput: OrderDetailsModelOutput {}
protocol OrderDetailsViewControllerOutput: OrderDetailsModelInput {}

class OrderDetailsViewController: UIViewController {

    var model: OrderDetailsViewControllerOutput!

    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        model.load()
        titleLabel.text = "№ \(model.currentOrderId)"
    }

    @IBAction func back(_ sender: Any) {
        model.back()
    }
}

extension OrderDetailsViewController: OrderDetailsViewControllerInput {
    
}
