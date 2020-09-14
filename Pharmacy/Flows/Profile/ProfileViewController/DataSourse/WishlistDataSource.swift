//
//  WishlistCellSection.swift
//  Pharmacy
//
//  Created by CGI-Kite on 08.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol WishListEditDelegate: class {
    func selectMedicineAt(index: Int)
    func deleteMedicine(id: Int)
}

final class WishlistDataSource: NSObject, UITableViewDataSource {
    
    var medicines: [Medicine] = []
    weak var wishlistDelegate: WishListEditDelegate?
    private let cellId: String = String(describing: MedicineCell.self)
    
    func assign(tableView: UITableView) {
        
        tableView.register(UINib(resource: R.nib.medicineCell), forCellReuseIdentifier: cellId)
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? MedicineCell else {
            return UITableViewCell()
        }
        cell.apply(medicine: medicines[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        wishlistDelegate?.selectMedicineAt(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if case .delete = editingStyle {
            
            tableView.beginUpdates()
            wishlistDelegate?.deleteMedicine(id: medicines[indexPath.row].id)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            medicines.remove(at: indexPath.row)
            tableView.endUpdates()
        }
    }
}
