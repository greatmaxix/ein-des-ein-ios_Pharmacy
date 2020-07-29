//
//  ProfileCoordinator.swift
//  Pharmacy
//
//  Created by CGI-Kite on 24.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import EventsTree

struct ProfileFlowConfiguration {
    
    let parent: EventNode
}

class ProfileFlowCoordinator: EventNode, Coordinator {
    
    private weak var root: ProfileViewController!
    private let storyboard: UIStoryboard = R.storyboard.profile()
    
    init(configuration: ProfileFlowConfiguration) {
        super.init(parent: configuration.parent)
        
    }
    
    func createFlow() -> UIViewController {
        // swiftlint:disable force_cast
        let profileVC: ProfileViewController = R.storyboard.profile().instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileVC.model = ProfileModel(parent: self)
        root = profileVC
        
        let navigationVC: UINavigationController = UINavigationController(rootViewController: root)
        navigationVC.isToolbarHidden = true

        addHandler { [weak self] (event: ProfileEvent) in
            switch event {
            case .editProfile:
                self?.presentEditProfile()
            default:
                break
            }
        }
        
        return navigationVC
    }
    
    func presentEditProfile() {
        
        guard let editProfileVC: EditProfileViewController = storyboard.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController else {
            return
        }
        
        let model = EditProfileModel(parent: self)
        model.output = editProfileVC
        editProfileVC.model = model
        root.navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    private func popController() {
        root.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TabBarEmbedCoordinable

extension ProfileFlowCoordinator: TabBarEmbedCoordinable {
    
    var tabItemInfo: TabBarItemInfo {
        // return TabBarItemInfo(title: R.string.localize.tabbarProfile(), icon: R.image.profileProxy(), highlightedIcon: R.image.profileProxy())
        return TabBarItemInfo(title: nil, icon: nil, highlightedIcon: nil)
    }
}
