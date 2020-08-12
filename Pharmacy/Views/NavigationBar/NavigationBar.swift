//
//  NavigationBar.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 08.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol NavigationBarDelegate: class {
    
}

protocol NavigationBarStyled {
    var style: NavigationBarStyle { get }
}

enum NavigationBarStyle {
    case large
    case normal
}

final class NavigationBar: UINavigationBar {
    
    fileprivate enum GUI {
        static let largeTitleFont = R.font.openSansBold(size: 32)!
        static let normalTitleFont = R.font.openSansBold(size: 16)!
        static let animationDurartion: TimeInterval = 0.3
        static let textFiledNormalTextColor = UIColor.white
        static let textFiledDarkTextColor = R.color.textDarkBlue()!
        static let largeHeight: CGFloat = 150
        static let smallHeight: CGFloat = 44
        static let cornerRadius: CGFloat = 10
        static let scanButtonCornerRadius: CGFloat = 6
        static let searchViewBackgorundAlpha: CGFloat = 0.3
        static let searchViewLargeBottomMargin: CGFloat = 16
        static let searchViewLargeLeftMargin: CGFloat = 16
        static let searchViewNormalBottomMargin: CGFloat = 8
    }
    
    var title: String? {
        set { titleLabel.text = newValue }
        get { titleLabel.text }
    }
    
    private var contentView: UIView!
    private var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var backButtonConstraint: NSLayoutConstraint!
    @IBOutlet private weak var searchViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var searchContainerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleCenterXConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleCenterYConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private weak var scanButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet private weak var cancelSearchButton: UIButton!
    @IBOutlet private weak var searchButton: UIButton!
    
    var style: NavigationBarStyle = .normal
    
    var height: CGFloat { heightBy(style: style) }
    
    var safeAreaHeight: CGFloat {
        let window = UIApplication.shared.keyWindow
        let topPadding = window?.safeAreaInsets.top
        return topPadding ?? 0
    }
    
    weak var homeDelegate: NavigationBarDelegate?
    
    //MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        config()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: height)
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        contentView.point(inside: point, with: event)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heightConstraint.constant = height
        backButtonConstraint.constant = safeAreaHeight
    }
    
    func heightBy(style: NavigationBarStyle) -> CGFloat {
        switch style {
        case .large:
            return GUI.largeHeight
        default:
            return GUI.smallHeight
        }
    }
    
    //MARK: - Actions
    
    @IBAction func scanButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        guard style == .normal else { return }
        textField.becomeFirstResponder()
        showSearchTextFieldAnimated()
    }
    
    @IBAction func cancelSearchAction(_ sender: UIButton) {
        endEditing(true)
        hideSearchTextFieldAnimated()
    }
}

extension NavigationBar {
    fileprivate func config() {
        clipsToBounds = false
        barStyle = .black
        titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.clear]
        tintColor = .clear
        barTintColor = R.color.welcomeBlue()
        isTranslucent = false
        
        contentView = configFromNib()!
        
        contentView.layer.cornerRadius = GUI.cornerRadius
        contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        scanButton.layer.cornerRadius = GUI.scanButtonCornerRadius
        searchView.layer.cornerRadius = searchView.bounds.height / 2
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        heightConstraint = contentView.heightAnchor.constraint(equalTo: heightAnchor)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            heightConstraint,
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
        ])
        
        configUIBy(style: style)
    }
    
    func configUIBy(style: NavigationBarStyle) {
        self.style = style
        let isLarge = style == .large
        
        endEditing(true)
        searchButton.isSelected = false
        cancelSearchButton.isHidden = true
        
        titleLabel.font = isLarge ? GUI.largeTitleFont : GUI.normalTitleFont
        
        titleLeadingConstraint.isActive = isLarge
        titleCenterXConstraint.isActive = !isLarge
        titleCenterYConstraint.isActive = !isLarge
        titleCenterYConstraint.constant = safeAreaHeight / 2 - titleLabel.font.pointSize / 2
        
        configSearchTextFieldBy(style: style)
        
        let searchViewColor = searchView.backgroundColor
        searchView.backgroundColor = searchViewColor?.withAlphaComponent(isLarge ? GUI.searchViewBackgorundAlpha : 0)
        
        scanButton.alpha = !isLarge ? 0 : 1
        backButton.alpha = isLarge ? 0 : 1
        titleBottomConstraint.isActive = isLarge
        searchContainerViewBottomConstraint.constant = isLarge
            ? GUI.searchViewLargeBottomMargin
            : GUI.searchViewNormalBottomMargin
    }
    
    func hideButtonsBy(style: NavigationBarStyle) {
        let isLarge = style == .large
        scanButton.isHidden = !isLarge
        backButton.isHidden = isLarge
    }
    
    private func configSearchTextFieldBy(style: NavigationBarStyle) {
        let isLarge = style == .large
        searchViewLeadingConstraint.constant = isLarge
        ? GUI.searchViewLargeLeftMargin
        : frame.width - GUI.searchViewLargeLeftMargin * 3
    }
    
    fileprivate func showSearchTextFieldAnimated() {
        searchButton.isSelected = true
        cancelSearchButton.isHidden = false
        
        textField.textColor = GUI.textFiledDarkTextColor
        configSearchTextFieldBy(style: .large)
        
        UIView.animate(withDuration: GUI.animationDurartion) {
            self.searchView.backgroundColor = .white
            self.layoutIfNeeded()
        }
    }
    
    fileprivate func hideSearchTextFieldAnimated() {
        searchButton.isSelected = false
        cancelSearchButton.isHidden = true
        
        textField.textColor = GUI.textFiledNormalTextColor
        configSearchTextFieldBy(style: style)
        
        UIView.animate(withDuration: GUI.animationDurartion) {
            self.searchView.backgroundColor = UIColor.white.withAlphaComponent(0)
            self.layoutIfNeeded()
        }
    }
}