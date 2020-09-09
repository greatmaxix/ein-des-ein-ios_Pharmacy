//
//  RegionsDataSource.swift
//  Pharmacy
//
//  Created by CGI-Kite on 07.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

struct RegionSection {
    var title: String = ""
    var regions: [Region] = []
    var cellId: String = String(describing: RegionCell.self)
    var headerId: String = String(describing: RegionHeaderCell.self)
}

final class RegionsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var sections: [RegionSection] = []
    private var alphabetCharacters: [String] = []
    var selectRegionClosure: ((_: Region) -> Void)?
    
    func update(sections: [RegionSection], alphabetCharacters: [String]) {
        
        self.sections = sections
        self.alphabetCharacters = alphabetCharacters
    }
    
    func assign(tableView: UITableView) {
                
        tableView.register(UINib(resource: R.nib.regionCell), forCellReuseIdentifier: String(describing: RegionCell.self))
        tableView.register(UINib(resource: R.nib.regionHeaderCell), forHeaderFooterViewReuseIdentifier: String(describing: RegionHeaderCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        tableView.sectionHeaderHeight = 40
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].regions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = sections[indexPath.section]
        if let cell = tableView.dequeueReusableCell(withIdentifier: section.cellId) as? RegionCell {
            cell.apply(region: section.regions[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: sections[section].headerId) as? RegionHeaderCell {
            header.apply(title: sections[section].title)
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectRegionClosure?(sections[indexPath.section].regions[indexPath.row])
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return alphabetCharacters
    }
}
