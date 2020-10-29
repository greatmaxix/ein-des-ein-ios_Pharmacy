//
//  CreateOrderViewController.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 29.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol CreateOrderViewControllerInput: CreateOrderModelOutput {}
protocol CreateOrderViewControllerOutput: CreateOrderModelInput {}

class CreateOrderViewController: UIViewController {

    var model: CreateOrderViewControllerOutput!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension CreateOrderViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }

}

extension CreateOrderViewController: CreateOrderViewControllerInput {

}
