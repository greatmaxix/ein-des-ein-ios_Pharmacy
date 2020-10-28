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
        
        addHandler { [weak self] (event: ProfileEvent) in
            switch event {
            case .editProfile:
                self?.presentEditProfile()
            case .openOrder:
                self?.presentMyOrders()
            case .openPrescriptions:
                self?.presentPrescriptions()
            case .openWishlist:
                self?.presentWishlist()
            case .openAnalize:
                self?.presentAnalizes()
            case .openAbout:
                self?.presentAbout()
            case .close:
                self?.popController()
            default:
                break
            }
        }
        
        addHandler { [weak self] (event: EditProfileEvent) in
            switch event {
            case .close:
                self?.popController()
            default:
                break
            }
        }
        
        addHandler { [weak self] (event: MedicineListModelEvent) in
            switch event {
            case .openProduct(let medicine):
                self?.openProductMedicineFor(medicine: medicine)
            default:
                break
            }
        }
      
        addHandler { [weak self] (event: AboutAppEvent) in
            switch event {
            case .close:
                self?.popController()
            default:
                break
            }
        }
    }
    
    func createFlow() -> UIViewController {
        // swiftlint:disable force_cast
        let profileVC: ProfileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        let model = ProfileModel(parent: self)
        profileVC.model = model
        model.output = profileVC
        root = profileVC
        
        let navigationVC: UINavigationController = UINavigationController(navigationBarClass: SimpleNavigationBar.self, toolbarClass: nil)
        navigationVC.setViewControllers([root], animated: false)
       
        navigationVC.isToolbarHidden = true
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
    
    func presentWishlist() {
        guard let wishlistVC: WishlistViewController = storyboard.instantiateViewController(withIdentifier: "WishlistViewController") as? WishlistViewController else {
                   return
        }
        
        let model = WishlistModel(parent: self)
        model.output = wishlistVC
        wishlistVC.model = model
        root.navigationController?.pushViewController(wishlistVC, animated: true)
    }
    
    func presentMyOrders() {
        guard let ordersVC: OrdersViewController = storyboard.instantiateViewController(withIdentifier: "OrdersViewController") as? OrdersViewController else {
                   return
        }
        
        let model = OrdersModel(parent: self)
        ordersVC.model = model
        root.navigationController?.pushViewController(ordersVC, animated: true)
    }
    
    func presentPrescriptions() {
        guard let prescriptionsVC: PrescriptionsViewController = storyboard.instantiateViewController(withIdentifier: "PrescriptionsViewController") as? PrescriptionsViewController else {
                   return
        }
        
        let model = PrescriptionsModel(parent: self)
        prescriptionsVC.model = model
        root.navigationController?.pushViewController(prescriptionsVC, animated: true)
    }
    
    func presentAnalizes() {
        guard let analizesVC: AnalizesViewController = storyboard.instantiateViewController(withIdentifier: "AnalizesViewController") as? AnalizesViewController else {
                   return
        }
        
        let model = AnalizesModel(parent: self)
        analizesVC.model = model
        root.navigationController?.pushViewController(analizesVC, animated: true)
    }
  
    func presentAbout() {
      guard let aboutVC: AboutAppViewController = storyboard.instantiateViewController(withIdentifier: "AboutAppViewController") as? AboutAppViewController else { return }
      
      let model = AboutAppModel(parent: self)
      aboutVC.model = model
      root.navigationController?.pushViewController(aboutVC, animated: true)
    }
    
    private func popController() {
        root.navigationController?.popViewController(animated: true)
    }
    
    private func openProductMedicineFor(medicine: Medicine) {
        let viewController =  R.storyboard.product.instantiateInitialViewController()!
        let model = ProductModel(product: medicine, parent: self)
        viewController.model = model
        model.output = viewController
        root.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - TabBarEmbedCoordinable

extension ProfileFlowCoordinator: TabBarEmbedCoordinable {
    
    var tabItemInfo: TabBarItemInfo {
    if let user = UserSession.shared.user, let avatarURL = user.avatarURL {
       let data = try? Data(contentsOf: avatarURL)
       let image = UIImage(data: data!)?.resizeImage(CGFloat.init(24), opaque: false).withRoundedCorners()
        
    return TabBarItemInfo(title: R.string.localize.tabbarProfile(),
                          icon: image?.withRenderingMode(.alwaysOriginal),
                          highlightedIcon: image?.withRenderingMode(.alwaysOriginal))
} else {
    return TabBarItemInfo(title: R.string.localize.tabbarProfile(),
                          icon: R.image.defaultProfilePhoto()?.withRenderingMode(.alwaysOriginal),
                          highlightedIcon: R.image.defaultProfilePhoto()?.withRenderingMode(.alwaysOriginal))
            
        }
    }
}
