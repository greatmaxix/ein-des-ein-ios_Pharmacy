//
//  NavigationBarWithSearchView.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 17.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

class NavigationBarWithSearchView: UIView {
    
    @IBOutlet private weak var frontView: UIView!
    @IBOutlet private var searchView: UIView!
    
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var searchTextField: UITextField!
    
    @IBOutlet var titleConteiner: UIView!
    var style: NavigationBarStyle = .normalWithSearch
    
    func setupStyle(style: NavigationBarStyle) {
        self.style = style
        if style == .normal {
            NSLayoutConstraint.activate([
                self.heightAnchor.constraint(equalToConstant: 44)
            ])
            hideSearch(true)
        } else if style == .normalWithSearch {
            hideSearch(false)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.configure()
    }
    
    // MARK: - Private
    private func configure() {
        searchView.backgroundColor = UIColor(displayP3Red: 255, green: 255, blue: 255, alpha: 0.3)
        searchView.layer.cornerRadius = 12
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
//        self.frontView.layer.cornerRadius = 12
     //   self.titleConteiner.clipsToBounds = true
//        self.frontView.clipsToBounds = true
      //  self.titleConteiner.layer.cornerRadius = 6
        searchTextField?.attributedPlaceholder = NSAttributedString(string: "Какие исследования вы ищите?",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    private func hideSearch(_ bool: Bool) {
        searchTextField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            self?.layoutIfNeeded()
        }, completion: {[weak self] _ in
            self?.searchView.isHidden = bool
        })
    }
}
