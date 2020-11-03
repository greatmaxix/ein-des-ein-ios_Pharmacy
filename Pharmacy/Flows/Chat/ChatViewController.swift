//
//  ChatViewController.swift
//  Pharmacy
//
//  Created by Egor Bozko on 03.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, NavigationBarStyled {
    
    var style: NavigationBarStyle = .normalWithoutSearch
    
    var model: ChatInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension ChatViewController: ChatOutput {
    
}
