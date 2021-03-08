//
//  PaymendSuccessfullyAlertController.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 04.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

class PaymendSuccessfullyAlertController: UIViewController {
    
    
    
    @IBOutlet var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
    }
    
    func configUI() {
        self.topView.layer.cornerRadius = 8
        
        self.view.backgroundColor = UIColor(red: 0, green: 0.039, blue: 0.387, alpha: 0.2)
    }
    @IBAction func okAction(_ sender: Any) {
        self.dismiss(animated: false)
    }
}
