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
    
    @IBOutlet weak var askLabel: UILabel!
    @IBOutlet weak var diagnosticLabel: UILabel!
    @IBOutlet weak var mapLabel: UILabel!
    
    @IBOutlet var buttonsBackground: [UIView]!
    
    @IBOutlet weak var loadReceipeButton: UIButton!
    @IBOutlet weak var watchCategoriesButton: UIButton!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    var model: WelcomeModelInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocalization()
        setupUI()
    }
    
    func setupLocalization() {
        
        titleLabel.text = R.string.localize.welcomeTitle()
        askLabel.text = R.string.localize.welcomeAsk()
        diagnosticLabel.text = R.string.localize.welcomeDiagnostic()
        mapLabel.text = R.string.localize.welcomeMap()
        
        loadReceipeButton.setTitle(R.string.localize.welcomeReceipe(), for: .normal)
        categoriesLabel.text = R.string.localize.welcomeCategories()
    }
    
    func setupUI() {
        barCodeButton.layer.cornerRadius = 6
        buttonsBackground.forEach({$0.layer.cornerRadius = 10})
        searchView.layer.cornerRadius = searchView.bounds.height / 2
        
        loadReceipeButton.layer.cornerRadius = loadReceipeButton.frame.height / 2
    }
    
}

extension WelcomeViewController: WelcomeModelOutput {
    
}
