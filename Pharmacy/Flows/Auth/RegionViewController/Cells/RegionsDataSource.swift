//
//  RegionsDataSource.swift
//  Pharmacy
//
//  Created by CGI-Kite on 07.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class RegionsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    struct RegionSection {
        var title: String = ""
        var regions: [Region] = []
        var cellId: String = String(describing: RegionCell.self)
        var headerId: String = String(describing: RegionHeaderCell.self)
    }
    
    private var sections: [RegionSection] = []
    var selectedRegion: Region?
    var alphabetCharacters: [Character] = []
    
    init(mainRegion: Region) {
        
        let subRegions = mainRegion.subRegions ?? [mainRegion]
        var allRegions: [Region] = []
        subRegions.forEach({
            if let regions = $0.subRegions {
                allRegions.append(contentsOf: regions)
            }
        })
        let regions = allRegions.sorted(by: { reg1, reg2 in
            reg1.name < reg2.name
        })
        
        if var firstCharacter: Character = regions[0].name.first {
            var section: RegionSection = RegionSection()
            for region in regions {
                if region.name.first == firstCharacter {
                    section.regions.append(region)
                } else {
                    section.title = String(firstCharacter)
                    sections.append(section)
                    alphabetCharacters.append(firstCharacter)
                    section = RegionSection()
                    section.regions.append(region)
                    firstCharacter = region.name.first ?? firstCharacter
                }
            }
        }
    }
    
    func assign(tableView: UITableView, alphabetView: AlphabetView) {
        
        alphabetView.setup(letters: alphabetCharacters)
        
        tableView.register(UINib(resource: R.nib.regionCell), forCellReuseIdentifier: String(describing: RegionCell.self))
        tableView.register(UINib(resource: R.nib.regionHeaderCell), forHeaderFooterViewReuseIdentifier: String(describing: RegionHeaderCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        tableView.sectionHeaderHeight = 44
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRegion = sections[indexPath.section].regions[indexPath.row]
    }
}
