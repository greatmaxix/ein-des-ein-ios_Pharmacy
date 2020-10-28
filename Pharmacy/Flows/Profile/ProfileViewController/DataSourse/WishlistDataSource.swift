//
//  WishlistCellSection.swift
//  Pharmacy
//
//  Created by CGI-Kite on 08.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

//protocol WishListEditDelegate: class {
//    func selectMedicineAt(index: Int)
//    func deleteMedicine(id: Int, index: IndexPath)
//}

//final class WishlistDataSource: NSObject, UITableViewDataSource {
    
//    var medicines: [Medicine] = []
//    weak var wishlistDelegate: WishListEditDelegate?
//    private let cellId: String = String(describing: MedicineCell.self)
    
//    func assign(tableView: UITableView) {
//
//        tableView.register(UINib(resource: R.nib.medicineCell), forCellReuseIdentifier: cellId)
//        tableView.dataSource = self
//    }
  
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if case .delete = editingStyle {
//
//            tableView.beginUpdates()
//            wishlistDelegate?.deleteMedicine(id: medicines[indexPath.row].id)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            medicines.remove(at: indexPath.row)
//            tableView.endUpdates()
//        }
//    }
//}
