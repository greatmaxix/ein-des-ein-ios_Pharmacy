//
//  MapGetDirections.swift
//  Pharmacy
//
//  Created by Egor Bozko on 28.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class MapGetDirections: UIView {

    @IBOutlet weak var appleMapButton: UIButton!
    @IBOutlet weak var googleMapButton: UIButton!
    @IBOutlet weak var uberButton: UIButton!
    @IBOutlet weak var close: LightRoundedButton!
    var closeAction: (() -> Void)?
    
    @IBAction func close(_ sender: Any) {
        closeAction?()
    }
}
