//
//  HomeViewController.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 08.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol HomeViewControllerInput: HomeModelOutput {}
protocol HomeViewControllerOutput: HomeModelInput {}

final class HomeViewController: UIViewController, HomeNavigationBarStyled{
    var model: HomeViewControllerOutput!
    
    var style: HomeNavigationBarStyle { .large }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    @IBAction func present(_ sender: Any) {
        let vc = UIViewController()
        vc.title = "new"
        vc.loadView()
        vc.view.backgroundColor = .red
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

//MARK: - HomeViewControllerInput

extension HomeViewController: HomeViewControllerInput {
    
}
