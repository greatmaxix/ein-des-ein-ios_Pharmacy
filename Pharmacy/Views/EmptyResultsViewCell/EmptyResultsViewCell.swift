//
//  EmptyResultsViewCell.swift
//  Pharmacy
//
//  Created by Sergey berdnik on 03.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class EmptyResultsViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var imageViewTopConstr: NSLayoutConstraint!
    
    /**
            Handler for catch tap on the main button adn adding reaction
     */
    var tapCellButtonHandler: EmptyClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel.font = R.font.openSansBold(size: 16)
        descriptionLabel.font = R.font.openSansRegular(size: 16)
        confirmButton.titleLabel?.font = R.font.openSansBold(size: 16)
        
        confirmButton.layer.cornerRadius = confirmButton.bounds.height / 2
        confirmButton.dropBlueShadow()
    }
    
    /**
            Setup cells view
            - Parameter title: enter String to set Title label
            - Parameter decriptionText: enter String to set Description label
            - Parameter buttonTitle: enter String to set buttonTitle label
            - Parameter buttonTitle: enter image name from Assets for setup
     */
    func setup(title: String, decriptionText: String, buttonTitle: String, imageName: String?) {
        titleLabel.text = title
        descriptionLabel.text = decriptionText
        confirmButton.setTitle(buttonTitle, for: .normal)
        if let name = imageName {
            self.emptyImageView.image = UIImage(named: name)
        }
    }
    
    @IBAction func tapConfirmButton(_ sender: UIButton) {
        self.tapCellButtonHandler?()
    }
}
