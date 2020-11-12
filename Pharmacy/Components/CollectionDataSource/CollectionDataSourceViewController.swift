//
//  CollectionDataSourceViewController.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 12.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

class CollectionDataSourceViewController: UIViewController {
    
    private enum GUI {
        static let defaultContentInset = UIEdgeInsets.all(16)
        static let defaultLayout = FlowLayoutStyle.grid(count: 1, height: 60)
    }
    
    enum FlowLayoutStyle {
        case grid(count: Int, height: CGFloat)
        case table
    }
    
    let constraintInsets: UIEdgeInsets
    let flowLayoutStyle: FlowLayoutStyle
    
    var contentInset = GUI.defaultContentInset
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout())
        view.addSubview(collectionView)
        collectionView.constraintsToSuperView(insets: constraintInsets)
        collectionView.contentInset = contentInset
        return collectionView
    }()
    
    init(constraintInsets: UIEdgeInsets = .zero,
         flowLayoutStyle: FlowLayoutStyle = GUI.defaultLayout) {
        self.constraintInsets = constraintInsets
        self.flowLayoutStyle = flowLayoutStyle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        constraintInsets = .zero
        flowLayoutStyle = GUI.defaultLayout
        super.init(coder: coder)
    }
    
    func assign<T>(dataSource: CollectionDataSource<T>) {
        dataSource.assign(collectionView: collectionView)
    }
    
    private func layout() -> UICollectionViewFlowLayout {
        switch flowLayoutStyle {
        case .grid(let count, let height):
            let layout = UICollectionViewFlowLayout()
            let length = CGFloat(count)
            let spacing = (contentInset.left + contentInset.right) / 2
            
            layout.minimumInteritemSpacing = spacing / 2
            layout.minimumLineSpacing = spacing
            let width = (view.bounds.width / length) - spacing - layout.minimumInteritemSpacing
            layout.itemSize = CGSize(width: width, height: height)
            return layout
        case .table:
            return UICollectionViewFlowLayout()
        }
    }
}
