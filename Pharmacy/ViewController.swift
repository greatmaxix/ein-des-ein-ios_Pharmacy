//
//  ViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 15.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import Moya

class ViewController: UIViewController {

    let manager = DataManager<AuthAPI, SampleResponseModel>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        manager.create(target: .requestCodeFor(phone: "123123")) { result in
            // 
        }
    }
}
