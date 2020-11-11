//
//  ChatGallery.swift
//  Pharmacy
//
//  Created by Egor Bozko on 10.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import InputBarAccessoryView
import Photos

final class ChatGallery: UICollectionView, InputItem {
    
    var inputBarAccessoryView: InputBarAccessoryView?
    var parentStackViewPosition: InputStackView.Position?
    var itemSize: CGSize {
        let width = (frame.width / 3.0) - 1
        return CGSize(width: width, height: width)
    }
    
    private var photos: PHFetchResult<PHAsset>!
    
    init(frame: CGRect) {
        let l = ChatGalleryLayout()
        super.init(frame: frame, collectionViewLayout: l)
        l.minimumLineSpacing = 1.0
        l.minimumInteritemSpacing = 1.0
        l.itemSize = itemSize
        setup()
    }
    
    func setup() {
        register(ChatGalleryCollectionViewCell.nib, forCellWithReuseIdentifier: ChatGalleryCollectionViewCell.reuseIdentifier)
        dataSource = self
        delegate = self
        decelerationRate = UIScrollView.DecelerationRate.fast
        backgroundColor = .white
        loadPhotos()
    }
    
    func loadPhotos() {
        let options = PHFetchOptions()
        photos = PHAsset.fetchAssets(with: .image, options: options)
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
        return frame.size
    }
}

extension ChatGallery: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatGalleryCollectionViewCell.reuseIdentifier, for: indexPath)
        let asset = photos[indexPath.row]
        
        (cell as? ChatGalleryCollectionViewCell)?.contentImage.fetchImage(asset: asset, contentMode: .aspectFill, targetSize: itemSize)
        
        return cell
    }
}

extension ChatGallery: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
}

class ChatGalleryLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else {
               let latestOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
               return latestOffset
        }
        // Page width used for estimating and calculating paging.
        let pageWidth = self.itemSize.height + self.minimumInteritemSpacing

        // Make an estimation of the current page position.
        let approximatePage = collectionView.contentOffset.y/pageWidth

        // Determine the current page based on velocity.
        let currentPage = velocity.y == 0 ? round(approximatePage) : (velocity.y < 0.0 ? floor(approximatePage) : ceil(approximatePage))

        // Create custom flickVelocity.
        let flickVelocity = velocity.y * 0.3

        // Check how many pages the user flicked, if <= 1 then flickedPages should return 0.
        let flickedPages = (abs(round(flickVelocity)) <= 1) ? 0 : round(flickVelocity)

        // Calculate newHorizontalOffset.
        let newVericallOffset = ((currentPage + flickedPages) * pageWidth) - collectionView.contentInset.bottom

        return CGPoint(x: proposedContentOffset.x, y: newVericallOffset)
    }
}
