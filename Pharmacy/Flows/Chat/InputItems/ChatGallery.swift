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

protocol ChatGalleryDelegate: class {
    func imageAction(action: ImageSelectionAction)
    func needHideGallery()
}

enum ImageSelectionAction {
    case select(LibraryImage), deselect(LibraryImage)
}

final class ChatGallery: UICollectionView, InputItem {
    
    var inputBarAccessoryView: InputBarAccessoryView?
    var parentStackViewPosition: InputStackView.Position?
    var itemSize: CGSize {
        let width = (frame.width / 3.0) - 1
        return CGSize(width: width, height: width)
    }
    
    weak var actionsDelegate: ChatGalleryDelegate?
    
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
        allowsMultipleSelection = true
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
        actionsDelegate?.needHideGallery()
    }
    
    override var intrinsicContentSize: CGSize {
        return frame.size
    }
}

extension ChatGallery: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatGalleryCollectionViewCell.reuseIdentifier, for: indexPath)
        if indexPath.row == 0 {
            (cell as? ChatGalleryCollectionViewCell)?.applyCameraStyle()
            return cell
        }
        let asset = photos[indexPath.row - 1]
        
        (cell as? ChatGalleryCollectionViewCell)?.fetchImage(asset: asset, indexPath: indexPath)
        cell.isSelected = collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return !(indexPath.row == 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ChatGalleryCollectionViewCell, let image = cell.image else { return }
        actionsDelegate?.imageAction(action: .select(image))
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ChatGalleryCollectionViewCell, let image = cell.image else { return }
        actionsDelegate?.imageAction(action: .deselect(image))
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

struct LibraryImage: Equatable {
    
    enum ImageSource {
        case library, gallery(IndexPath)
    }
    
    let original: UIImage
    let placeholder: UIImage
    let url: URL
    let source: ImageSource?
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.url.absoluteString == rhs.url.absoluteString
    }
    
    init(data: Data, info: [AnyHashable: Any]?, source: ImageSource? = nil) {
        original = UIImage(data: data)!
        placeholder = UIImage(data: data, scale: 0.2)!
        url = (info?["PHImageFileURLKey"] as? URL) ?? URL(string: "empty")!
        self.source = source
    }
    
    init(originalImage: UIImage, url: URL, source: ImageSource? = nil) {
        original = originalImage
        placeholder = originalImage
        self.url = url
        self.source = source
    }
}
