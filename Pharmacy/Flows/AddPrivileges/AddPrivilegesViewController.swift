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

class AddPrivilegesViewController: UIViewController {
    
    var model: AddPrivilegesViewControllerOutput!
    
    @IBOutlet var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    private func configure() {
        self.infoLabel.text = "Уже в следующих версиях! Следите за обновленями!"
    }
}



extension AddPrivilegesViewController: SimpleNavigationBarDelegate {
    
    func leftBarItemAction() {
        model.close()
    }
    
    func rightBarItemAction() {
        
    }
}

extension AddPrivilegesViewController: AddPrivilegesViewControllerInput {
    
    func didFetchError(error: Error) {
        
    }
}
