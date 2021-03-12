//
//  SearchController.swift
//  Pharmacy
//
//  Created by Egor Bozko on 02.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class SearchController: UISearchController {

    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        setupSearchBar()
        searchBar.placeholder = R.string.localize.basketEmptyButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSearchBar() {
        searchBar.searchBarStyle = .prominent
        obscuresBackgroundDuringPresentation = false
        searchBar.setSearchFieldBackgroundImage(R.image.search_Field_active(), for: .normal)
    }
}
