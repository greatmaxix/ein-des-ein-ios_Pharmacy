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
    case openChat
    case openAnalizes
    case openReceipts
}

protocol WelcomeModelOutput: class {
    func showReadyOrders(orders: [String])
    func showReceipts(_ receipts: [Medicine])
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
    func removeFromWishList(productId: Int)
    func openReceiptUpload()
    func openMedicineDetail(medicine: Medicine)
    func openChat()
    func openDiagnosis()
    func openMap()
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
    func openMedicineDetail(medicine: Medicine) {
       raise(event: MedicineListModelEvent.openProduct(medicine))
    }
    
    func openCategories(_ categoryIndex: Int?) {
        if let index = categoryIndex {
            let category = topCategory[index]
            raise(event: WelcomeEvent.openCategories(category: category))
        } else {
            raise(event: WelcomeEvent.openCategories(category: nil))
        }
        raise(event: TabBarEvent.userWantsToChangeTab(newTab: .catalogue))
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
        
        var recenvMedicineViewed: [Medicine] = []
        
        guard data.count >= 2 else {return}

        var arraySlice = data.suffix(2)
        arraySlice.reverse()
        let newArray = Array(arraySlice)
        
        for item in newArray {
            
            let receipt = Medicine(title: item.name, minPrice: item.minPrice, maxPrice: item.maxPrice, imageURL: item.imageURL, releaseForm: item.releaseForm, liked: item.liked, productId: item.productId)
    
            recenvMedicineViewed.append(receipt)
        }
        
        output.showReceipts(recenvMedicineViewed)
    }
    
    private func loadCategoryData() {
        provider.load(target: .getCategories(startCode: nil, maxLevel: nil), completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.topCategory = response.categories
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
    
    func removeFromWishList(productId: Int) {
        wishListProvider.load(target: .removeFromWishList(medicineId: productId)) { (result) in
            switch result {
            case .success:
                break
                //self.medicines[indexPath.row].liked = false
            case .failure(let error):
                print("error is \(error.localizedDescription)")
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
        raise(event: WelcomeEvent.openReceipts)
    }

    func openMap() {
        raise(event: WelcomeEvent.openMap)
    }

    func openChat() {
        raise(event: WelcomeEvent.openChat)
    }

    func openDiagnosis() {
        raise(event: WelcomeEvent.openAnalizes)
    }
}
