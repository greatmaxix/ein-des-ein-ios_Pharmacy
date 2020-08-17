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
    func close()
    func getUser() -> User?
}

class EditProfileModel: EventNode {
    unowned var output: EditProfileOutput!
    
    private var profileImage: UIImage?
    
    private func updateUser(newUser: User) {
        
    }
    
    private func updateImage() {
        
    }
}

extension EditProfileModel: EditProfileInput {
    
    func saveImage(image: UIImage) {
        self.profileImage = image
    }
    
    func saveProfile(name: String, phone: String, email: String) {
        if let oldProfile = getUser() {
            //let user = User(name: name, email: email, phone: phone, uuid: oldProfile.uuid)
            //updateUser(newUser: user)
        }
    }
    
    func getUser() -> User? {
        return UserDefaults.standard.getCurrentUser()
    }
    
    func close() {
        raise(event: EditProfileEvent.close)
    }
}
