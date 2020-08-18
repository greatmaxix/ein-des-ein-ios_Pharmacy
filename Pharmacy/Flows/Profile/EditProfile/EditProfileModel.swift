//
//  EditProfileModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 29.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import Moya
import EventsTree

enum EditProfileEvent: Event {
    case close
    case openPhoto
}

protocol EditProfileInput: class {
    
    func saveImage(image: UIImage, mime: String, fileName: String)
    func saveProfile(name: String, email: String)
    func close()
    func getUser() -> User?
}

class EditProfileModel: EventNode {
    
    unowned var output: EditProfileOutput!
    private var profileImage: UIImage?
    private let provider: DataManager<ProfileAPI, ProfileResponse> = DataManager<ProfileAPI, ProfileResponse>()
    private let imageProvider: DataManager<ProfileAPI, CustomerImageResponse> = DataManager<ProfileAPI, CustomerImageResponse>()
    
    private var user: User!
    private var mime: String = ""
    private var imageFileName: String = ""
    
    init(parent: EventNode?, user: User) {
        super.init(parent: parent)
        self.user = user
    }
    
    private func updateUser(name: String, email: String, avatarUuid: String) {
        
        provider.load(target: .updateCustomer(name: name, email: email, avatarUuid: avatarUuid)) { [weak self] (result) in
            switch result {
            case .success(let response):
                let newUser = response.user
                UserSession.shared.save(user: newUser, token: nil)
                self?.raise(event: EditProfileEvent.close)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateImage() {
        
        if let data = profileImage?.pngData() ?? profileImage?.jpegData(compressionQuality: 1) {
            imageProvider.load(target: .sendImage(imageData: data, mime: mime, fileName: imageFileName)) { [weak self] (result) in
                
                guard let self = self else {return}
                switch result {
                case .success(let response):
                    self.user.avatar = response.avatar
                    UserSession.shared.save(user: self.user, token: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension EditProfileModel: EditProfileInput {
    
    func saveImage(image: UIImage, mime: String, fileName: String) {
        self.profileImage = image
        self.mime = mime
        self.imageFileName = fileName
        updateImage()
    }
    
    func saveProfile(name: String, email: String) {
        updateUser(name: name, email: email, avatarUuid: user.avatar?.uuid ?? "")
    }
    
    func getUser() -> User? {
        return UserDefaults.standard.getCurrentUser()
    }
    
    func close() {
        raise(event: EditProfileEvent.close)
    }
}
