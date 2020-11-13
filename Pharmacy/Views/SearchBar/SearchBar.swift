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
    func searchBarDidCancel()
}

class SearchBar: UIView, NibView {
    
    // MARK: - Outlets
    @IBOutlet private(set) weak var textField: UITextField!
    @IBOutlet private(set) weak var cancelButton: UIButton!
    
    // MARK: - Properties
    weak var delegate: SearchBarDelegate?
    var searchBarHandler: (() -> Bool)?
    
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
    
    @IBAction private func onCancelButtonTouchUp(_ sender: UIButton) {
        textField.text = nil
        delegate?.searchBarDidCancel()
    }
    
    @objc private  func textFieldDidChange(_ textField: UITextField) {
        let textContent = textField.text ?? ""
        cancelButton.isHidden = textContent.count == 0
        
        delegate?.searchBar(self, textDidChange: textContent)
    }
}

// MARK: - Private methods
extension SearchBar {
    
    private func initialize() {
        self.clipsToBounds = true
        self.textField.placeholder = R.string.localize.welcomeSearchBarPlaceholder()
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
}

// MARK: - UITextFieldDelegate
extension SearchBar: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return searchBarHandler?() ?? true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.searchBarSearchButtonClicked(self)
        
        return textField.resignFirstResponder()
    }
}
