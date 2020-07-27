//
//  WelcomeViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 27.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var barCodeButton: UIButton!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var searchView: UIView!
    
    var model: WelcomeModelInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocalization()
        setupUI()
    }
    
    func setupLocalization() {
        titleLabel.text = R.string.localize.welcomeTitle()
    }
    
    func setupUI() {
        barCodeButton.layer.cornerRadius = 6
        searchView.layer.cornerRadius = searchView.bounds.height / 2
    }
    
}

extension WelcomeViewController: WelcomeModelOutput {
    
}
