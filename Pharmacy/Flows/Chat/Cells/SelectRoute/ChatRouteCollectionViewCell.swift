//
//  ChatRouteCollectionViewCell.swift
//  Pharmacy
//
//  Created by Egor Bozko on 03.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class ChatRouteCollectionViewCell: UICollectionViewCell {
    
    enum SelectedRoute {
        case none, doctor, pharmacist
    }
    
    @IBOutlet weak var confirmButton: UIButton! {
        didSet {
            self.confirmButton.decorationBlackShadow()
        }
    }
    @IBOutlet weak var pharmacistButton: UIButton! {
        didSet {
            self.pharmacistButton.decorationBlackShadow()
        }
    }
    @IBOutlet weak var doctorButton: UIButton! {
        didSet {
            self.doctorButton.decorationBlackShadow()
        }
    }
    
    private var selecetedRoute = SelectedRoute.none {
        didSet {
            switch selecetedRoute {
            case .none:
                pharmacistButton.backgroundColor = .clear
                doctorButton.backgroundColor = .clear
                confirmButton.isEnabled = true
            case .doctor:
                pharmacistButton.backgroundColor = .clear
                doctorButton.backgroundColor = R.color.welcomeBlue()
                confirmButton.isEnabled = true
            case .pharmacist:
                pharmacistButton.backgroundColor = R.color.welcomeBlue()
                doctorButton.backgroundColor = .white
                confirmButton.isEnabled = true
            }
        }
    }
    
    @IBAction func doctorPressed(_ sender: UIButton) {
        selecetedRoute = .doctor
    }
 
    @IBAction func pharmacistPressed(_ sender: UIButton) {
        selecetedRoute = .pharmacist
    }
    
    @IBAction func confirmChoise(_ sender: Any) {
        
    }
}
