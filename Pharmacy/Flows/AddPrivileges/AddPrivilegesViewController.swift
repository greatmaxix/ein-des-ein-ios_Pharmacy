//
//  AddPrivilegesViewController.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 24.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit


protocol AddPrivilegesViewControllerOutput: AddPrivilegesModelInput {}
protocol AddPrivilegesViewControllerInput: AddPrivilegesModelOutput {}

class AddPrivilegesViewController: UIViewController, NavigationBarStyled {
    
    var style: NavigationBarStyle = .normalWithoutSearch
    
    var model: AddPrivilegesViewControllerOutput!
    
    @IBOutlet var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let bar = self.navigationController?.navigationBar as? NavigationBar {
            bar.smallNavBarTitleLabel.text = "addPrivileges"
        }
    }
    private func configure() {
        self.infoLabel.text = "Уже в следующих версиях! Следите за обновленями!"
    }
}

extension AddPrivilegesViewController: AddPrivilegesViewControllerInput {
    
    func didFetchError(error: Error) {
        
    }
}
