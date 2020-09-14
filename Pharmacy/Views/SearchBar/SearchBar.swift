//
//  SearchBar.swift
//  Pharmacy
//
//  Created by Sapa Denys on 10.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol SearchBarDelegate: class {
    func searchBar(_ searchBar: SearchBar, textDidChange searchText: String)
    func searchBarSearchButtonClicked(_ searchBar: SearchBar)
}

class SearchBar: UIView, NibView {
    
    // MARK: - Outlets
    @IBOutlet private weak var textField: UITextField!
    
    // MARK: - Properties
    weak var delegate: SearchBarDelegate?
    
    override var intrinsicContentSize: CGSize {
      return UIView.layoutFittingExpandedSize
    }
    
    // MARK: - Init / Deinit Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViewFromNib()
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadViewFromNib()
        initialize()
    }
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = bounds.height / 2
    }
}

// MARK: - Actions
extension SearchBar {
    
    @objc private  func textFieldDidChange(_ textField: UITextField) {
        delegate?.searchBar(self, textDidChange: textField.text ?? "")
    }
}

extension SearchBar {
    
    private func initialize() {
        
        self.clipsToBounds = true
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
}

extension SearchBar: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.searchBarSearchButtonClicked(self)
        
        return true
    }
}
