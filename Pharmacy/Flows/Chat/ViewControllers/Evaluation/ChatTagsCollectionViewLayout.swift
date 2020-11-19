//
//  ChatTagsCollectionViewLayout.swift
//  Pharmacy
//
//  Created by Egor Bozko on 18.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class ChatTagsCollectionViewLayout: UICollectionViewFlowLayout {
    
    private var previousAttributes: UICollectionViewLayoutAttributes?
    
    func procces(attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let p = previousAttributes else {
            previousAttributes = attributes
            return attributes
        }
        
        if p.frame.origin.y == attributes.frame.origin.y {
            attributes.frame.origin.x = p.frame.maxX + 16.0
        }
        previousAttributes = attributes
        
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        guard let a = attributes else { return nil }
        return a.map({ a in
            procces(attributes: a)
        })
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)
        guard let a = attributes else { return nil }
        return procces(attributes: a)
    }
    
}
