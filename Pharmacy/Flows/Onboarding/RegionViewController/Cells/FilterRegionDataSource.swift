//
//  FilterRegionDataSource.swift
//  Pharmacy
//
//  Created by CGI-Kite on 08.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class FilterRegionsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var allRegions: [Region] = [] {
        didSet {
            filteredRegions = allRegions
        }
    }
    private var filteredRegions: [Region] = []
    var selectRegionClosure: ((_: Region) -> Void)?
    
    init(mainRegion: Region) {
        
        let subRegions = mainRegion.subRegions ?? [mainRegion]
        var allRegions: [Region] = []
        subRegions.forEach({
            if let regions = $0.subRegions {
                allRegions.append(contentsOf: regions)
            }
        })
        self.allRegions = allRegions
        filteredRegions = allRegions
    }
    
    func assign(tableView: UITableView) {
                
        tableView.register(UINib(resource: R.nib.regionCell), forCellReuseIdentifier: String(describing: RegionCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        tableView.reloadData()
    }

    func filterRegions(searchText: String) {
        filteredRegions = allRegions.filter({$0.name.lowercased().contains(searchText.lowercased())})
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRegions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RegionCell.self)) as? RegionCell {
            cell.apply(region: filteredRegions[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectRegionClosure?(filteredRegions[indexPath.row])
    }
}
