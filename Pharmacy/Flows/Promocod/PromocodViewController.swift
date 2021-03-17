//
//  PromocodViewController.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 04.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

protocol PromocodViewControllerInput: PromocodModelOutput {}
protocol PromocodViewControllerOutput: PromocodModelInput {}

class PromocodViewController: UIViewController, NavigationBarStyled {
    
    var style: NavigationBarStyle = .normalWithoutSearch
    
    @IBOutlet var textAlert: UILabel!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var topView: UIView!
    
    var model: PromocodViewControllerOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        configUI()

    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func usePromoAction(_ sender: Any) {
        self.dismiss(animated: true)
        model.use()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let bar = self.navigationController?.navigationBar as? NavigationBar {
            bar.smallNavBarTitleLabel.text = R.string.localize.checkoutPromocode.localized()
        }
    }

    func configUI() {
        self.topView.layer.cornerRadius = 8
        
        self.view.backgroundColor = UIColor(red: 0, green: 0.039, blue: 0.387, alpha: 0.2)
    }
}

extension PromocodViewController: PromocodViewControllerInput {
    
    func didLoad(models: [PaymentModel]) {
        
    }
    
    func didFetchError(error: Error) {
        
    }
}
