//
//  SimpleNavigationBarView.swift
//  Pharmacy
//
//  Created by CGI-Kite on 19.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class SimpleNavigationBarView: UIView {

    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    
    var cancelSearchViewButtonHandler: EmptyClosure?

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchLeadingConstraint: NSLayoutConstraint!
    
    var style: NavigationBarStyle = .normal
    
    var shouldHideRightButton = false
    
    override func awakeFromNib() {
        frontView.layer.cornerRadius = 10
        searchView.layer.cornerRadius = (searchView.frame.height / 2)
        frontView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        frontView.clipsToBounds = true
        dropBlueShadow()
    }
    
    func setupStyle(style: NavigationBarStyle) {
        self.style = style
        if style == .normal {
            self.shouldHideRightButton = false
            hideSearch()
            leftButton.setTitle("", for: .normal)
            rightButton.removeTarget(self, action: #selector(showSearch), for: .touchUpInside)
            rightButton.setImage(nil, for: .normal)
        } else if style == .search {
            rightButton.isHidden = false
            rightButton.setImage(R.image.welcomeSearch(), for: .normal)
            rightButton.setTitle("", for: .normal)
            rightButton.addTarget(self, action: #selector(showSearch), for: .touchUpInside)
        }
    }
    
    @IBAction func clearSearch(_ sender: Any) {
        textField.text = nil
        cancelSearchViewButtonHandler?()
        shouldHideRightButton = false
        hideSearch()
    }
    
    @IBAction func hideSearch(_ sender: Any) {
        shouldHideRightButton = false
        hideSearch()
    }
    
    @objc private func showSearch() {
        searchLeadingConstraint.constant = GUI.searchVisible
        searchView.isHidden = false
        leftButton.isHidden = true
        rightButton.isHidden = true
        titleLabel.isHidden = true

        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            self?.layoutIfNeeded()
        })
    }
    
    private func hideSearch() {
        textField.resignFirstResponder()
        searchLeadingConstraint.constant = GUI.searchHidden
        self.leftButton.isHidden = false

        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            self.searchView.isHidden = true
            self.titleLabel.isHidden = false
            self.rightButton.isHidden = self.shouldHideRightButton
        })
    }
    
    func finishSearch() {
        self.shouldHideRightButton = true
        self.hideSearch()
    }
}

fileprivate extension SimpleNavigationBarView {
    struct GUI {
        static let searchHidden: CGFloat = 350
        static let searchVisible: CGFloat = 16
    }
}
