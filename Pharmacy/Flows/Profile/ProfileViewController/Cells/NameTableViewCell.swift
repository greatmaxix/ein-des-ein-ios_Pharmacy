//
//  NameTableViewCell.swift
//  testProjs7472
//
//  Created by CGI-Kite on 23.06.2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit

class NameTableViewCellData: BaseCellData {
    
    var image: UIImage?
    var name: String
    var phone: String
    
    override var nibName: String? {
        return String(describing: NameTableViewCell.self)
    }

    override var cellHeight: CGFloat {
        return UITableView.automaticDimension
    }
    
    init(image: UIImage?, name: String, phone: String) {
        self.image = image
        self.name = name
        self.phone = phone
    }
    var editProfile: ((_: ProfileEvent) -> Void)?
}

class NameTableViewCell: BaseTableViewCell {

    @IBOutlet private weak var customerImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
        
    private var editProfileHandler: ((_: ProfileEvent) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customerImageView.layer.cornerRadius = customerImageView.frame.width / 2
        selectionStyle = .none
        editButton.layer.cornerRadius = editButton.frame.height / 2
    }
    
    override func setup(cellData: BaseCellData) {
        if let cd: NameTableViewCellData = cellData as? NameTableViewCellData {
            
            customerImageView.image = cd.image
            nameLabel.text = cd.name
            phoneLabel.text = cd.phone
            editProfileHandler = cd.editProfile
        }
    }
    
    @IBAction func editProfile(_ sender: Any) {
        editProfileHandler?(ProfileEvent.editProfile)
    }
}
