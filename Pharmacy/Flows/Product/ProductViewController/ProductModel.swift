//
//  ProductModel.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 13.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

enum ProductModelEvent: Event {
    case openAnalogsFor(Product)
    case openCatalogsFor(Product)
    case openMap(Product)
    case openFarmacyList([PharmacyModel])
    case openCheckout
}

protocol ProductModelInput: class {
    var dataSource: TableDataSource<ProductCellSection> { get }
    var title: String { get }
    func load()
    func didSelectCell(at indexPath: IndexPath)
    func openMap()
}

protocol ProductModelOutput: class {
    func didLoad(product: Product)
}

final class ProductModel: Model {
    
    weak var output: ProductModelOutput!
    private let medicine: Medicine
    private var product: Product!
    let dataSource = TableDataSource<ProductCellSection>()
    
    init(product: Medicine, parent: EventNode?) {
        self.medicine = product
        super.init(parent: parent)
    }
}

// MARK: - ProductViewControllerOutput

extension ProductModel: ProductViewControllerOutput {
    
    var title: String { "Ношпа" }
    
    func load() {
        
//        product = Product(imageURLs: [], title: "АЛЛОПУРИНОЛ-ЭГИС, 40 мг", subtitle: "Таблетки шипучие, 24 шт", description: "Таблетки покрытые пленочной оболочкой от светло-серого до темно-серого цвета, капсуловидной формы, сгравировкой \"PRENATAL\" с одной стороны и \"FORTE\" с другой стороны, со специфическим запахом", fromPrice: "568", toPrice: "568", currency: "$", analog: "Дротаверин", category: "Противогрибковый", tags: ["Спазмы", "Язва", "Головная боль", "Гастрит", "Болит живот", "Дисменорея"], company: "Chinoin Pharmaceutical and Chemical Works Co. Венгрия")
        dataSource.cells = ProductCellSection.allSectionsFor(product: product)
        output.didLoad(product: product)
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        guard let cell = dataSource.cell(for: indexPath) else { return }
        
        switch cell {
        case .analog(let product):
            raise(event: ProductModelEvent.openAnalogsFor(product))
        case .category(let product):
            raise(event: ProductModelEvent.openCatalogsFor(product))
        default:
            return
        }
    }
    
    func openMap() {
        raise(event: ProductModelEvent.openMap(product))
    }
}
