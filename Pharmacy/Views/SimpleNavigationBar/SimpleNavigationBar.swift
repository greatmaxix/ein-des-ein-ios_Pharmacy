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
    }
    
    @objc private func leftItemAction() {
        barDelegate?.leftBarItemAction()
    }
    
    @objc private func rightItemAction() {
        barDelegate?.rightBarItemAction()
    }
}

fileprivate extension SimpleNavigationBar {
    
    struct Const {
        static let cornerRadius: CGFloat = 12.0
        static let barHeight: CGFloat = 44
    }
}