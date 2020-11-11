//
//  OrderCommentCell.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 30.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol CommentCellProtocol: class {
    func valueChanged(comment: String)
}

class OrderCommentCell: UITableViewCell {

    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var corneredView: UIView!

    weak var delegate: CommentCellProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()

        textview.delegate = self
        textview.backgroundColor = R.color.backgroundGray()

        corneredView.layer.borderWidth = 1
        corneredView.layer.borderColor = R.color.mediumGrey()?.cgColor
        corneredView.backgroundColor = R.color.backgroundGray()
    }
    
}

extension OrderCommentCell: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        corneredView.layer.borderColor = R.color.welcomeBlue()?.cgColor
        corneredView.backgroundColor = .white
        textview.backgroundColor = .white
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        corneredView.layer.borderColor = R.color.mediumGrey()?.cgColor
        corneredView.backgroundColor = R.color.backgroundGray()
        textview.backgroundColor = R.color.backgroundGray()
    }

    func textViewDidChange(_ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))

        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
        }

        delegate?.valueChanged(comment: textview.text)
    }

}
