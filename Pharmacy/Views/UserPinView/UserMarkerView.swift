//
//  UserMarker.swift
//  Waldo
//
//  Created by Mishko on 4/27/20.
//  Copyright © 2020 Yaroslav Bykov. All rights reserved.
//

import UIKit

class UserMarkerView: UIView {
    
    @IBOutlet weak var centerCircleView: UIView!
    @IBOutlet weak var directionTriangle: UIImageView!
    @IBOutlet weak var directionCenterConstr: NSLayoutConstraint!
    @IBOutlet weak var directionCenterXConstr: NSLayoutConstraint!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        
        layer.cornerRadius = bounds.width / 2
        centerCircleView.layer.cornerRadius = centerCircleView.bounds.width / 2
        centerCircleView.layer.borderWidth = 2
        centerCircleView.layer.borderColor = UIColor.white.cgColor
        layer.borderColor = R.color.welcomeBlue()?.cgColor
        layer.borderWidth = 2
    }
}
