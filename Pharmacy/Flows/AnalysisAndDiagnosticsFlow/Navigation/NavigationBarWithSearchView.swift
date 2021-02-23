//
//  NavigationBarWithSearchView.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 17.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit




class NavigationBarWithSearchView: UIView {
    
    @IBOutlet weak var frontView: UIView!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var searchView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var searchTextField: UITextField!
    
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
        
        //        self.titleLabel?.text = "Анализы"
        searchTextField?.attributedPlaceholder = NSAttributedString(string: "Какие исследования вы ищите?",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    private func hideSearch(_ bool: Bool) {
        searchTextField.resignFirstResponder()
        //        self.leftButton.isHidden = !bool
        
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            self?.layoutIfNeeded()
        }, completion: {[weak self] _ in
            self?.searchView.isHidden = bool
            //            self?.titleLabel.isHidden = !bool
            
        })
    }
}
