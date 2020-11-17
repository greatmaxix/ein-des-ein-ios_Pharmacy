//
//  ChatEvaluationViewController.swift
//  Pharmacy
//
//  Created by Egor Bozko on 17.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class ChatEvaluationViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtittleLabel: UILabel!
    @IBOutlet weak var CommentsView: UIView!
    @IBOutlet weak var starsView: UIStackView!
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    @IBOutlet weak var tagsCollection: UICollectionView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func nextAction(_ sender: Any) {
    }
    
    @IBAction func laterAction(_ sender: Any) {
    }
    
    @IBAction func starAction(_ sender: UIButton) {
        
    }
    
}
