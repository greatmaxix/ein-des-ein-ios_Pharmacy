//
//  SimpleWithSearchNavigationBar.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 19.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

protocol SimpleWithSearchNavigationBarDelegate: class {
    func leftBarItemAction()
    func rightBarItemAction()
    func search(returnText: String)
    func cancelSearch()
}

extension SimpleWithSearchNavigationBarDelegate {
    func search(returnText: String) {}
    func cancelSearch() {}
}

final class SimpleWithSearchNavigationBar: UINavigationBar {

    private var contentView: NavigationBarWithSearchView!
    
    weak var barDelegate: SimpleWithSearchNavigationBarDelegate?

    var title: String? {
        get {
            contentView.titleLabel.text
        }
        set {
            contentView.titleLabel.text = newValue
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
        nil
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
        true
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
    
    func setupUI() {
        self.subviews.forEach {
            $0.removeFromSuperview()
        }

        tintColor = .clear
        barTintColor = R.color.welcomeBlue()
        isTranslucent = false
        
        setBackgroundImage(UIImage(), for: .default)
        
        contentView = R.nib.navigationBarWithSearchView(owner: nil)
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
        contentView.searchTextField.delegate = self
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
}

// MARK: - UITextFieldDelegate

extension SimpleWithSearchNavigationBar: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        barDelegate?.search(returnText: textField.text ?? "")
        return textField.resignFirstResponder()
    }
    
}

private extension SimpleWithSearchNavigationBar {
    
    struct Const {
        static let cornerRadius: CGFloat = 12.0
        static let barHeight: CGFloat = 100
        static let smallBarHeight: CGFloat = 44
    }
}
