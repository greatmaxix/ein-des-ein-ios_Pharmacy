//
//  WelcomeModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 27.07.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

enum WelcomeEvent: Event {
    
    case openMap
    case openBarCodeReader
    case openCategories(category: Category?)
}

protocol WelcomeModelOutput: class {
    func showReadyOrders(orders: [String])
    func showReceipts(_ receipts: [Receipt])
    func modelIsLoaded()
}

protocol WelcomeModelInput: class {
    func load()
    func openSearchScreen()
    var categories: [Category] {get}
    func didSelectProductBy(index: Int)
    func openCategories(_ categoryIndex: Int?)
    func addToCart(productId: Int)
    func addToWishList(productId: Int)
    func openReceiptUpload()
}

final class WelcomeModel: EventNode {
    
    unowned var output: WelcomeModelOutput!
    private let provider = DataManager<CategoryAPI, CategoriesResponse>()
    
    private let cartProvider = DataManager<ProductCartAPI, PostResponse>()
    
    private let wishListProvider = DataManager<WishListAPI, PostResponse>()
    
    private var topCategory: [Category] = []
    private(set) var medicines: [Medicine] = []
}

extension WelcomeModel: WelcomeModelInput {
    func openCategories(_ categoryIndex: Int?) {
        if let index = categoryIndex {
            let category = topCategory[index]
            raise(event: WelcomeEvent.openCategories(category: category))
        } else {
            raise(event: WelcomeEvent.openCategories(category: nil))
        }
    }
    
    func didSelectProductBy(index: Int) {
        guard index <= topCategory.endIndex else {
            return
        }
        raise(event: MedicineListModelEvent.openProduct(medicines[index]))
    }
    
    func openSearchScreen() {
        raise(event: TabBarEvent.userWantsToChangeTab(newTab: .search))
    }
    
    var categories: [Category] {
            return topCategory
    }
    
    func load() {
        loadReadyOrders()
        loadReceipts()
        loadCategoryData()
    }
    
    private func loadReadyOrders() {
// заглушка для получения готовых заказов
//        let orders = ["34542", "90100"]
//        output.showReadyOrders(orders: orders)
    }
    
    private func loadReceipts() {
        let data = UserSession.shared.recentMedicineViewed
        var result: [Receipt] = []
        
        guard data.count >= 2 else {return}
        
        for index in 0...1 {
            let medicine = data[index]
            let receipt = Receipt(title: medicine.name, subtitle: medicine.releaseForm, imageURL: URL(string: medicine.picture), liked: medicine.liked, price: medicine.minPrice, productId: medicine.productId)
            result.append(receipt)
        }
        
        output.showReceipts(result)
    }
    
    private func loadCategoryData() {
        provider.load(target: .getCategories(startCode: nil, maxLevel: nil), completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                var secondLevelCategories: [Category] = []
                
                for category in response.categories[0...3] {
                    if let subCategories = category.subCategories {
                        secondLevelCategories.append(contentsOf: subCategories)
                    }
                    if category.code != "H" {
                        break
                    }
                }
                self.topCategory = secondLevelCategories
                self.output.modelIsLoaded()
                //self.reloadCategories()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func addToCart(productId: Int) {
        cartProvider.load(target: .addPharmacyToCart(productId: productId)) {[weak self] result in
            guard self != nil else { return }
            
            switch result {
            case .success:
                print("reciept \(productId) was successfully added to chart")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func addToWishList(productId: Int) {
        wishListProvider.load(target: .addToWishList(medicineId: productId)) { result in
            switch result {
            case .success:
                print("reciept \(productId) was successfully added to chart")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func openReceiptUpload() {
        raise(event: AppEvent.presentInDev)
    }
}
