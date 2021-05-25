//
//  SimpleNavigationBar.swift
//  Pharmacy
//
//  Created by CGI-Kite on 19.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol SimpleNavigationBarDelegate: class {
    func leftBarItemAction()
    func rightBarItemAction()
    func search(returnText: String)
    func cancelSearch()
}

extension SimpleNavigationBarDelegate {
    func search(returnText: String) {}
    func cancelSearch() {}
}

final class SimpleNavigationBar: UINavigationBar {

    private var contentView: SimpleNavigationBarView!
    
    weak var barDelegate: SimpleNavigationBarDelegate?

    var title: String? {
        get {
            contentView.titleLabel.text
        }
        set {
            contentView.titleLabel.text = newValue
        }
    }
    var isTitleHidden: Bool {
        get {
            contentView.titleLabel.isHidden
        }
        set {
            contentView.titleLabel.isHidden = newValue
        }
    }

    
    var leftItemTitle: String? {
        get {
            contentView.leftButton.title(for: .normal)
        }
        set {
            contentView.leftButton.setTitle(newValue, for: .normal)
        }
    }
    
    var rightItemTitle: String? {
        get {
            contentView.rightButton.title(for: .normal)
        }
        set {
            contentView.rightButton.setTitle(newValue, for: .normal)
        }
    }
    
    var isLeftItemHidden: Bool {
        get {
            contentView.leftButton.isHidden
        }
        set {
            contentView.leftButton.isHidden = newValue
        }
    }
    var isRightItemHidden: Bool {
        get {
            contentView.rightButton.isHidden
        }
        set {
            contentView.rightButton.isHidden = newValue
        }
    }
    
    var isSearchHidden: Bool {
        get {
            contentView.searchButton.isHidden
        }
        set {
            contentView.searchButton.isHidden = newValue
        }
    }
    
    var style: NavigationBarStyle {
        get {
            return contentView.style
        }
        set {
            contentView.setupStyle(style: newValue)
        }
    }
    
    // MARK: - setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
        
        tintColor = .clear
        barTintColor = R.color.welcomeBlue()
        isTranslucent = false
        barStyle = .black
        
        setBackgroundImage(UIImage(), for: .default)
        
        contentView = R.nib.simpleNavigationBarView(owner: nil)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentView)
        sendSubviewToBack(contentView)
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: Const.barHeight),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        contentView.leftButton.addTarget(self, action: #selector(leftItemAction), for: .touchUpInside)
        contentView.rightButton.addTarget(self, action: #selector(rightItemAction), for: .touchUpInside)
        contentView.searchButton.addTarget(self, action: #selector(cancelSearchAction), for: .touchUpInside)
        contentView.textField.delegate = self
        
        contentView.cancelSearchViewButtonHandler = {[weak self] in
            self?.barDelegate?.cancelSearch()
        }
    }
    
    @objc private func leftItemAction() {
        barDelegate?.leftBarItemAction()
    }
    
    @objc private func rightItemAction() {
        barDelegate?.rightBarItemAction()
    }
    
    @objc private func cancelSearchAction() {
        barDelegate?.cancelSearch()
    }
    
    func setup(placeholder: String) {
        contentView.textField.placeholder = placeholder
    }
}

// MARK: - UITextFieldDelegate

extension SimpleNavigationBar: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        barDelegate?.search(returnText: textField.text ?? "")
        return textField.resignFirstResponder()
    }
    
}

private extension SimpleNavigationBar {
    
    struct Const {
        static let cornerRadius: CGFloat = 12.0
        static let barHeight: CGFloat = 44
    }
}
