//
//  InDevelopmentViewController.swift
//  Pharmacy
//
//  Created by Ekateryna Maslova on 27.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

struct InDevelopmentModel {
    let title: String
    let subTitle: String
    let image: String
}


class InDevelopmentViewController: UIViewController {

    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageInDelivary: UIImageView!
    
    var model: InDevelopmentModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

// MARK: - Actions
    @IBAction func closePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func configure() {
        subTitleLabel.text = model.subTitle
        titleLabel.text = model.title
        imageInDelivary.image = UIImage(named: model.image)
    }
}
