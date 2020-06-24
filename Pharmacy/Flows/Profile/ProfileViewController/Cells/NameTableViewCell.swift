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
        return 80
    }
    
    init(image: UIImage?, name: String, phone: String) {
        self.image = image
        self.name = name
        self.phone = phone
    }
}

class NameTableViewCell: BaseTableViewCell {

    @IBOutlet weak var customerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customerImageView.layer.cornerRadius = customerImageView.frame.width / 2
        selectionStyle = .none
        backgroundColor = .white
    }
    
    override func setup(cellData: BaseCellData) {
        if let cd: NameTableViewCellData = cellData as? NameTableViewCellData {
            
            customerImageView.image = cd.image
            nameLabel.text = cd.name
            phoneLabel.text = cd.phone
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
