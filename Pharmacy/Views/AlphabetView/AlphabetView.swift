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
    private var labels: [UILabel]!
    private var letters: [Character]!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    func setup() {
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
            label.font = R.font.openSansBold(size: Int(bounds.height) / letters.count)
            label.textColor = R.color.welcomeBlue()
            labels.append(label)
            stackView.addArrangedSubview(label)
        })
    }

    func selectSymbolsInRange(range: Range<Int>) {
        
    }
}
