//
//  CatalogueViewController.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 07.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol CatalogueViewControllerInput: CatalogueModelOutput {}
protocol CatalogueViewControllerOutput: CatalogueModelInput {}

final class CatalogueViewController: UIViewController {
    var model: CatalogueViewControllerOutput!
}

// MARK: - MapViewControllerInput

extension CatalogueViewController: CatalogueViewControllerInput {
    
}
