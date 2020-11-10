//
//  AttachInputItem.swift
//  Pharmacy
//
//  Created by Egor Bozko on 06.11.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import InputBarAccessoryView

class AttachInputItem: InputBarButtonItem {
    
    struct GUI {
        static let rect = CGRect(x: 0.0, y: 0.0, width: 60.0, height: 55.0)
        static let imageRect = CGRect(x: 14.0, y: 0.0, width: 26.0, height: 50.0)
        
        static func imageRect(for content: CGRect) -> CGRect {
            let r = imageRect
            return CGRect(x: (content.width - r.width) / 2, y: (content.height - r.height) / 2, width: r.width, height: r.height)
        }
    }
    
    init(view: InputBarAccessoryView?, action: @escaping InputBarButtonItemAction) {
        super.init(frame: GUI.rect)
        inputBarAccessoryView = view
        imageView?.contentMode = .scaleAspectFit
        setImage(R.image.attachment(), for: .normal)
        setImage(R.image.attachmentHighlighted(), for: .highlighted)
        onTouchUpInside(action)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return GUI.imageRect(for: contentRect)
    }
}
