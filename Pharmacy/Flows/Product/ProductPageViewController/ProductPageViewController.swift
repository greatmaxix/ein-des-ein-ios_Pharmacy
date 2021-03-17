//
//  ProductPageViewController.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 13.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class ProductPageViewController: UIViewController {
   
    @IBOutlet private weak var tagButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet var infoLabel: UILabel!
    
    static func createWith(image: UIImage, title: String) -> ProductPageViewController {
        let vc = ProductPageViewController(nib: R.nib.productPageViewController)
        vc.loadView()
        vc.imageView.image = image
        vc.tagButton.setTitle(title, for: .normal)
        return vc
    }
    
    static func createWith(url: URL, title: String) -> ProductPageViewController {
        let vc = ProductPageViewController(nib: R.nib.productPageViewController)
        vc.loadView()
        vc.imageView.loadImageBy(url: url)
        vc.tagButton.setTitle(title, for: .normal)
        return vc
    }
    
    func localized() {
        infoLabel.text = R.string.localize.product_image_info.localized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localized()
    }
}
