//
//  ProfileModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 24.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

protocol ProfileInput {
    var controlsCount: Int { get }
    func selectActionAt(index: Int) -> (() -> Void)?
    func cellDataAt(index: Int) -> BaseCellData
}

final class ProfileModel: Model {
    
    private var cellsData: [BaseCellData] = []
    
    override init(parent: EventNode?) {
        super.init(parent: parent)
        
        setupDataSource()
    }

    private func setupDataSource() {
        
        cellsData = []
        do {
            let cellData: NameTableViewCellData = NameTableViewCellData(image: nil, name: "Name Surname", phone: "+111 111 111 1111")
            cellsData.append(cellData)
        }
        do {
            let cellData: EmptyTableViewCellData = EmptyTableViewCellData(height: 24.5, color: UIColor.gray)
            cellsData.append(cellData)
        }
        do {
            let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profileRegion(), additionalInfo: "Москва", type: .region)
            cellsData.append(cellData)
        }
        do {
            let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profileOrders())
            cellsData.append(cellData)
        }
        do {
            let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profileReceipes())
            cellsData.append(cellData)
        }
        do {
            let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profilePayment(), additionalInfo: "1000$", type: .paiment)
            cellsData.append(cellData)
        }
        do {
            let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profileNotifications())
            cellsData.append(cellData)
        }
        do {
            let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profileAddress())
            cellsData.append(cellData)
        }
        do {
            let cellData: EmptyTableViewCellData = EmptyTableViewCellData(height: 24.5, color: UIColor.gray)
            cellsData.append(cellData)
        }
        do {
            let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profileAbout())
            cellsData.append(cellData)
        }
        do {
            let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profileQuestions())
            cellsData.append(cellData)
        }
        do {
            let cellData: EmptyTableViewCellData = EmptyTableViewCellData(height: 24.5, color: UIColor.gray)
            cellsData.append(cellData)
        }
        do {
            let cellData: ProfileTableViewCellData = ProfileTableViewCellData(title: R.string.localize.profileExit(), type: .exit)
            cellsData.append(cellData)
        }
        do {
            let cellData: EmptyTableViewCellData = EmptyTableViewCellData(height: 24.5, color: UIColor.gray)
            cellsData.append(cellData)
        }
    }
}

// MARK: - ProfileInput

extension ProfileModel: ProfileInput {
    
    var controlsCount: Int {
        return cellsData.count
    }
    
    func cellDataAt(index: Int) -> BaseCellData {
        return cellsData[index]
    }
    
    func selectActionAt(index: Int)-> (()-> Void)? {
        cellsData[index].selectHandler
    }
}
