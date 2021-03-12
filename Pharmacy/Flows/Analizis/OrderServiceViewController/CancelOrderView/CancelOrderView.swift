//
//  CancelOrderView.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 09.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit


protocol CancelOrderViewOutput: CancelOrderViewModelInput {}
protocol CancelOrderViewInput: CancelOrderViewModelOutput {}

class CancelOrderView: UIViewController {
    
    
    @IBOutlet var allertView: UIView!
    var model: CancelOrderViewOutput!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allertView.layer.cornerRadius = 8
        self.view.backgroundColor = UIColor(red: 0, green: 0.039, blue: 0.387, alpha: 0.2)
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: false)

        
    }
}

extension CancelOrderView: CancelOrderViewModelOutput {


}
