//
//  ChatGallery.swift
//  Pharmacy
//
//  Created by Egor Bozko on 10.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import InputBarAccessoryView

final class ChatGallery: UICollectionView, InputItem {
    
    var inputBarAccessoryView: InputBarAccessoryView?
    var parentStackViewPosition: InputStackView.Position?
    
    private var size: CGSize = CGSize(width: 200, height: 200) {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    init() {
        let l = UICollectionViewFlowLayout()
        l.minimumLineSpacing = 1.0
        super.init(frame: .zero, collectionViewLayout: l)
        register(ChatGalleryCollectionViewCell.nib, forCellWithReuseIdentifier: ChatGalleryCollectionViewCell.reuseIdentifier)
        dataSource = self
        delegate = self
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidChangeAction(with textView: InputTextView) {
        
    }
    
    func keyboardSwipeGestureAction(with gesture: UISwipeGestureRecognizer) {
        
    }
    
    func keyboardEditingEndsAction() {
        
    }
    
    func keyboardEditingBeginsAction() {
        
    }
    
    override var intrinsicContentSize: CGSize {
        return size
    }
    
    func setSize(_ newValue: CGSize?, animated: Bool) {
        size = newValue ?? .zero
    }
}

extension ChatGallery: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatGalleryCollectionViewCell.reuseIdentifier, for: indexPath)
        return cell
    }
}

extension ChatGallery: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width / 3.0)
        return CGSize(width: width - 2, height: width - 2)
    }
}
