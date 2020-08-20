//
//  NameTableViewCell.swift
//  testProjs7472
//
//  Created by CGI-Kite on 23.06.2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit
import Kingfisher

class NameTableViewCellData: BaseCellData {
    
    var imageUrl: URL?
    var name: String
    var phone: String
    
    override var nibName: String? {
        return String(describing: NameTableViewCell.self)
    }

    override var cellHeight: CGFloat {
        return 104
    }
    
    init(imageUrl: URL?, name: String, phone: String) {
        self.imageUrl = imageUrl
        self.name = name
        self.phone = phone
    }
    var editProfile: EmptyClosure?
}

class NameTableViewCell: BaseTableViewCell {

    @IBOutlet private weak var customerImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
        
    private var editProfileHandler: EmptyClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customerImageView.layer.cornerRadius = customerImageView.frame.width / 2
        selectionStyle = .none
        editButton.layer.cornerRadius = editButton.frame.height / 2
        editButton.dropBlueShadow()
    }
    
    override func setup(cellData: BaseCellData) {
        if let cd: NameTableViewCellData = cellData as? NameTableViewCellData {
            
            if let url = cd.imageUrl {
                customerImageView.loadImageBy(url: url)
            }
            nameLabel.text = cd.name
            phoneLabel.text = cd.phone

            if !cd.phone.contains("+") {
                phoneLabel.text = "+" + cd.phone
            }
            editProfileHandler = cd.editProfile
        }
    }
    
    @IBAction func editProfile(_ sender: Any) {
        editProfileHandler?()
    }
}
