//
//  AlphaHighlightedView.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 14.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

extension AlphaHighlightedView where Self: UITableViewCell {
    var view: UIView { contentView }
}

extension AlphaHighlightedView where Self: UICollectionViewCell {
    var view: UIView { contentView }
}

extension AlphaHighlightedView where Self: ContainerView {
    var view: UIView { containerView }
}

protocol AlphaHighlightedView {
    var alpha: CGFloat { get }
    var highlightedAlpha: CGFloat { get }
    var view: UIView { get }
}

extension AlphaHighlightedView {
    var alpha: CGFloat { 1 }
    var highlightedAlpha: CGFloat { 0.6 }
    
    func highlight(_ highlighted: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.1 :  0, animations: {
            self.view.alpha = highlighted ? self.highlightedAlpha : self.alpha
        })
    }
}
