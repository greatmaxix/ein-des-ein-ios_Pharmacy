//
//  EditProfileModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 29.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

enum EditProfileEvent: Event {
    case close
    case openPhoto
}

protocol EditProfileInput: class {
    
    func saveImage(image: UIImage)
    func saveProfile(name: String, phone: String, email: String)
}

protocol EditProfileOutput: class {
}

class EditProfileModel: EventNode {
    unowned var output: EditProfileOutput!
}

extension EditProfileModel: EditProfileInput {
    
    func saveImage(image: UIImage) {
        
    }
    func saveProfile(name: String, phone: String, email: String) {
        
    }
}
