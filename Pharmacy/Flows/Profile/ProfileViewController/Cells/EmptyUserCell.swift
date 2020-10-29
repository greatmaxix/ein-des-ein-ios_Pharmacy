//
//  EmptyUserCell.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 28.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class EmptyUserCellData: BaseCellData {

    override var nibName: String? {
        String(describing: EmptyUserCell.self)
    }

    override var cellHeight: CGFloat {
        200
    }

    var authorize: EmptyClosure?

}

class EmptyUserCell: BaseTableViewCell {

    var authActionHandler: EmptyClosure?

    override func setup(cellData: BaseCellData) {
        if let cd: EmptyUserCellData = cellData as? EmptyUserCellData {

            authActionHandler = cd.authorize
        }
    }

    @IBAction func auth(_ sender: Any) {
        authActionHandler?()
    }

}
