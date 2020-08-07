//
//  SearchViewController.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 07.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol SearchViewControllerInput: SearchModelOutput {}
protocol SearchViewControllerOutput: SearchModelInput {}

final class SearchViewController: UIViewController {
    var model: SearchViewControllerOutput!
}

//MARK: - SearchViewControllerInput

extension SearchViewController: SearchViewControllerInput {
    
}
