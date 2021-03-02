//
//  TableAdapterBaseCell.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 02.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

public struct F {
    
    public typealias Handler<Type> = (Type) -> ()
}

protocol AnyCellType: UITableViewCell {
    
    func fill(with model: Any, eventHandler: F.Handler<Any>?)
}

open class BaseCell<Model, Events>: UITableViewCell, AnyCellType {
    
    //MARK: -
    //MARK: Accesors
    
    public var eventHandler: F.Handler<Events>?
    
    //MARK: -
    //MARK: View Lifycycle
    
    override open func awakeFromNib() {
        super.awakeFromNib()

        self.configure()
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
    open override func prepareForReuse() {
        self.eventHandler = nil
        
        super.prepareForReuse()
    }

    open func configure() {

    }
    
    //MARK: -
    //MARK: AnyCellType
    
    func fill(with model: Any, eventHandler: F.Handler<Any>?) {
        if let value = model as? Model {
            self.eventHandler = {
                eventHandler?($0)
            }
            
            self.fill(with: value)
        }
    }
    
    open func fill(with model: Model) {
//        fatalError("Abstract method used for child classes")
    }
}

class UnselectableCell<Model, Events>: BaseCell<Model, Events> {
    
}

