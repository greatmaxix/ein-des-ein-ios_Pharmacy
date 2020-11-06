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
    case profileUpdated
    case openPhoto
}

protocol EditProfileInput: class {
    
    func saveImage(image: UIImage, mime: String, fileName: String)
    func saveProfile(name: String, email: String)
    func close()
    func getUser() -> UserDisplayable?
    
    var name: String {get}
    var phone: String {get}
    var email: String? {get}
    var imageUrl: URL? {get}
}
protocol EditProfileOutput: class {
    func savingImageSuccess()
}

final class EditProfileModel: EventNode {
    
    unowned var output: EditProfileOutput!
    private var profileImage: UIImage?
    private let provider: DataManager<ProfileAPI, ProfileResponse> = DataManager<ProfileAPI, ProfileResponse>()
    private let imageProvider: DataManager<ProfileAPI, CustomerImageResponse> = DataManager<ProfileAPI, CustomerImageResponse>()
    
    private var user: UserDisplayable!
    private var mime: String = ""
    private var imageFileName: String = ""
    
    override init(parent: EventNode?) {
        super.init(parent: parent)
        self.user = UserSession.shared.user
    }
    
    private func updateUser(name: String, email: String, avatarUuid: String) {
        
        provider.load(target: .updateCustomer(name: name, email: email, avatarUuid: avatarUuid)) { [weak self] (result) in

            guard let `self` = self else { return }

            switch result {
            case .success(let response):
                let newUser = response.user
                UserSession.shared.save(user: newUser, token: nil)
                self.raise(event: EditProfileEvent.profileUpdated)
                self.raise(event: EditProfileEvent.close)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateImage() {
        
        if let data = profileImage?.jpegData(compressionQuality: 0.5) {
            imageProvider.load(target: .sendImage(imageData: data, mime: mime, fileName: imageFileName)) { [weak self] (result) in
                guard let self = self else {return}
                switch result {
                case .success(let response):
                    UserSession.shared.save(avatar: response.avatar)
                    self.user = UserSession.shared.user
                    self.output.savingImageSuccess()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension EditProfileModel: EditProfileInput {
    var name: String {
        user.name
    }
    
    var phone: String {
        user.phone
    }
    
    var email: String? {
        user.email
    }
    
    var imageUrl: URL? {
        user.avatarURL
    }
    
    func saveImage(image: UIImage, mime: String, fileName: String) {
        self.profileImage = image
        self.mime = mime
        self.imageFileName = fileName
        updateImage()
    }
    
    func saveProfile(name: String, email: String) {
        updateUser(name: name, email: email, avatarUuid: UserSession.shared.avatarUUID ?? "")
        
    }
    
    func getUser() -> UserDisplayable? {
        return UserSession.shared.user
    }
    
    func close() {
        raise(event: EditProfileEvent.close)
    }
}
