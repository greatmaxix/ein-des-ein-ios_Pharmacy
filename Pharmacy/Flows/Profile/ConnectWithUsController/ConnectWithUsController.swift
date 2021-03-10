//
//  ConnectWithUsController.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 09.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit


class ConnectWithUsController: UIViewController {
    var style: NavigationBarStyle = .normal
    
    @IBOutlet var commentTextView: UITextView!
    
    @IBOutlet var textViewComment: UITextView!
    @IBOutlet var cancelButton: UIButton!
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        
        self.commentTextView.delegate = self
        super.viewDidLoad()
        self.configure()
        self.setupUI()
    }
    
    func configure() {
        self.cancelButton.layer .cornerRadius = 14
        self.cancelButton.backgroundColor = UIColor(red: 0.145, green: 0.4, blue: 0.976, alpha: 1)
        textViewComment.layer.borderColor = UIColor(red: 0.859, green: 0.882, blue: 0.922, alpha: 1).cgColor
        textViewComment.layer.borderWidth = 1
        textViewComment.layer.cornerRadius = 10
    }
    
    private func setupUI() {
        if let bar = self.navigationController?.navigationBar as? SimpleNavigationBar {
            bar.title = "Связаться с нами"
            bar.leftItemTitle = "Назад"
        }
     
    }
}


extension ConnectWithUsController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == R.string.localize.checkoutAddComment() {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Оставить комменатарий"
            textView.textColor = .lightGray
        }
    }
}
