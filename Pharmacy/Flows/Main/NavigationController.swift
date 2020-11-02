//
//  NavigationController.swift
//  Pharmacy
//
//  Created by Egor Bozko on 02.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let backItem = UIBarButtonItem()
        backItem.title = " "
        viewController.navigationItem.backBarButtonItem = backItem
        super.pushViewController(viewController, animated: animated)
    }
    
    private func setupNavigationBar() {
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.tintColor = .white
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
}
