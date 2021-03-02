//
//  TableAdapterSection.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 02.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

public struct SectionHeader {
    
    let view: UIView?
    let height: CGFloat
    
    static func create(color: UIColor, height: CGFloat) -> SectionHeader {
        let view = UIView()
        view.backgroundColor = color

        return SectionHeader(view: view, height: height)
    }
}

public struct Section {
    
    //MARK: -
    //MARK: Accesors
    
    let cell: AnyCellType.Type
    let header: SectionHeader?
    var models: [Any]
    let eventHandler: ((Any) -> ())?
    let isEditing: Bool
    
    //MARK: -
    //MARK: Initializations
    
    //TO-DO: Wrap event handler into WeakBox
    public init<Cell, Model, EventsType>(
        cell: Cell.Type,
        models: [Model],
        eventHandler: F.Handler<EventsType>? = nil,
        header: SectionHeader? = nil,
        isEditing: Bool = false
    )
        where Cell: BaseCell<Model, EventsType>
    {
        self.cell = cell
        self.models = models
        self.header = header
        self.isEditing = isEditing
        self.eventHandler = {
            if let event = $0 as? EventsType {
                eventHandler?(event)
            }
        }
    }

    public init<Cell, Model, EventsType>(
        cell: Cell.Type,
        model: Model,
        eventHandler: F.Handler<EventsType>? = nil,
        header: SectionHeader? = nil,
        isEditing: Bool = false
    )
        where Cell: BaseCell<Model, EventsType>
    {
        self.init(cell: cell,
                  models: [model],
                  eventHandler: eventHandler,
                  header: header,
                  isEditing: isEditing)
    }
}

