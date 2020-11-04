//
//  ChatCoordinator.swift
//  Pharmacy
//
//  Created by Egor Bozko on 03.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

final class ChatCoordinator: EventNode, Coordinator {
    
    weak var navigation: UINavigationController?
    
    func createFlow() -> UIViewController {
        let vc = ChatViewController()
        vc.resignFirstResponder()
        let model = ChatModel(parent: self)
        vc.model = model
        model.output = vc
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    init(parent: EventNode?, navigation: UINavigationController) {
        super.init(parent: parent)
        self.navigation = navigation
        
        addHandler(.onRaise) {(event: ChatEvent) in
            switch event {
            case .close:
                navigation.popViewController(animated: true)
            }
        }
    }
}
