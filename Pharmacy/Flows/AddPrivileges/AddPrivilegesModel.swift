//
//  AddPrivilegesModel.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 24.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation


protocol AddPrivilegesModelInput: class {
    func close()
}

protocol AddPrivilegesModelOutput: class {
    func didFetchError(error: Error)
}


final class AddPrivilegesModel: Model {
    
    weak var output: AddPrivilegesViewControllerOutput!
}

extension AddPrivilegesModel: AddPrivilegesViewControllerOutput {
    func close() {
      //  raise(event: ProfileEvent.back)
    }
}
