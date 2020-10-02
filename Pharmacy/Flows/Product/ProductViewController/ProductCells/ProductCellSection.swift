//
//  ProductCellSection.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 13.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol ProductCellSections: TableCellSection {
    var product: Product { get }
}

enum ProductCellSection: ProductCellSections {

    case info(Product)
    case analog(Product)
    case category(Product)
    case description(Product)
    case instruction(Product)
    case advice(Product)
    case questions(Product)
    
    static func allSectionsFor(product: Product) -> [ProductCellSection] {
        [
            .info(product),
            .analog(product),
            .category(product),
            .description(product),
            .instruction(product),
            .advice(product),
            .questions(product)
        ]
    }
    
    var product: Product {
        switch self {
        case .info(let product),
             .analog(let product),
             .category(let product),
             .advice(let product),
             .description(let product),
             .instruction(let product),
             .questions(let product):
            return product
        }
    }
    
    func reuseIdentifier() -> String {
       String(describing: self)
    }
    
    func cellType() -> UITableViewCell.Type? {
        switch self {
        case .info:
            return ProductInfoTableViewCell.self
        case .analog:
            return ProductAnalogTableViewCell.self
        case .category:
            return ProductCategoryTableViewCell.self
        case .description:
            return ProductDescriptionTableViewCell.self
        case .instruction:
            return ProductInstructionTableViewCell.self
        case .questions:
            return ProductQuestionsTableViewCell.self
        case .advice:
            return ProductAdviceTableViewCell.self
        }
    }
    
    func apply(cell: UITableViewCell) {
        switch cell {
        case let cell as ProductInfoTableViewCell:
            cell.apply(product: product)
        case let cell as ProductAnalogTableViewCell:
            cell.apply(product: product)
        case let cell as ProductCategoryTableViewCell:
            cell.apply(product: product)
        case let cell as ProductDescriptionTableViewCell:
            cell.apply(product: product)
        default:
            return
        }
    }
    
    func config(cell: UITableViewCell) {
        switch cell {
        case let cell as ProductInfoTableViewCell:
            cell.showSeparator()
        default:
            cell.hideSeparator()
        }
    }
}
