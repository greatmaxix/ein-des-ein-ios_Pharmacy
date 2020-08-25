//
//  FarmacySelectionViewController.swift
//  Pharmacy
//
//  Created by CGI-Kite on 25.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import TTGTagCollectionView

final class FarmacySelectionViewController: UIViewController {
    
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var tagsView: TTGTagCollectionView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageHeightConstraint: NSLayoutConstraint!
    
    var model: FarmacySelectionInput!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
