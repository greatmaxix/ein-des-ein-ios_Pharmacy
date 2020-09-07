//
//  AlphabetView.swift
//  testProjs7472
//
//  Created by CGI-Kite on 04.09.2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit

final class AlphabetView: UIView {

    private var stackView: UIStackView!
    private var labels: [UILabel] = []
    private var letters: [Character]!// = (97...122).map({Character(UnicodeScalar($0))})
    
    func setup(letters: [Character]) {
        subviews.forEach({$0.removeFromSuperview()})
        
        backgroundColor = .clear
        
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        letters.forEach({
            let label = UILabel()
            label.text = String($0)
            label.font = R.font.openSansBold(size: bounds.height / CGFloat(letters.count) * 0.7)
            label.textColor = R.color.lightBlue()
            labels.append(label)
            stackView.addArrangedSubview(label)
        })
    }

    func selectSymbolsInRange(range: Range<Int>) {
        
    }
}
