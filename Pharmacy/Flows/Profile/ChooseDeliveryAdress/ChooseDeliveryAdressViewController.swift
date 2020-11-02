//
//  ChooseDeliveryAdressViewController.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 02.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class ChooseDeliveryAdressViewController: UIViewController {
    var model: ChooseDeliveryAdressInput!
    private var activityIndicator: MBProgressHUD!
    
        override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = setupActivityIndicator()
        setupNavBar()
    }
    
    private func setupNavBar() {
      if let bar = navigationController?.navigationBar as? SimpleNavigationBar {
        bar.style = .search
        bar.isLeftItemHidden = false
        bar.isRightItemHidden = true
        bar.title = "Delivery Adress"
        bar.leftItemTitle = R.string.localize.profileProfile()
        bar.barDelegate = self
      }
    }
}

extension ChooseDeliveryAdressViewController : ChooseDeliveryAdressOutput {
    
}

extension ChooseDeliveryAdressViewController : SimpleNavigationBarDelegate {
    func leftBarItemAction() {
        model.close()
    }
    
    func rightBarItemAction() {
        
    }
}
