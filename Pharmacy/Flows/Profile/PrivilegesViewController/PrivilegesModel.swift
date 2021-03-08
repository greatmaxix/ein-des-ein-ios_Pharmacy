//
//  PrivilegesModel.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 24.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation

protocol PrivilegesModelInput: class {
    func didSelectCell(at indexPath: IndexPath)
    func close()
    func openAddDocument()
}

protocol PrivilegesModelOutput: class {

    func didFetchError(error: Error)

}


final class PrivilegesModel: Model {
    
    weak var output: PrivilegesModelOutput!
    private let laboratoryProvider = DataManager<DeteilLaboratorAPI, LaboratoryDetailModel>()
    private var laboratoryList: [LaboratoryDetailModel] = []
}

extension PrivilegesModel: PrivilegesControllerOutput {
   
    func openAddDocument() {
        self.raise(event: ProfileEvent.openAddPrivileges)
    }
    

    func close() {
        raise(event: ProfileEvent.close)
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        self.openAddDocument()
    }
}
