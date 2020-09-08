//
//  RegionModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 04.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import EventsTree

protocol RegionInput: class {
    var dataSource: RegionsDataSource { get }
    var filterDataSource: FilterRegionsDataSource { get }
    var title: String { get }
    func filterRegions(text: String, tableView: UITableView)
    func load()
    func close()
}

protocol RegionOutput: class {
    func reloadRegions()
}

final class RegionModel: EventNode {
    
    fileprivate var regionDataSource: RegionsDataSource!
    fileprivate var filterDataSourse: FilterRegionsDataSource!
    fileprivate let provider = DataManager<LocationAPI, RegionResponse>()
    unowned var output: RegionOutput!
    
    func setupDataSource(regions: [Region]) {
        
        if let region: Region = regions.first {
            regionDataSource = RegionsDataSource(mainRegion: region)
            filterDataSourse = FilterRegionsDataSource(mainRegion: region)
            filterDataSourse.selectRegionClosure = { [weak self] selectedRegion in
                self?.close()
                self?.saveRegion(region: selectedRegion)
            }
            regionDataSource.selectRegionClosure = { [weak self] selectedRegion in
                self?.close()
                self?.saveRegion(region: selectedRegion)
            }
            output.reloadRegions()
        }
    }
    
    func saveRegion(region: Region) {
        
    }
}

extension RegionModel: RegionInput {
    
    var title: String {
        return R.string.localize.regionTitle()
    }
    
    var dataSource: RegionsDataSource {
        return regionDataSource
    }
    
    var filterDataSource: FilterRegionsDataSource {
        return filterDataSourse
    }
    
    func filterRegions(text: String, tableView: UITableView) {
        if text != "" {
            if !(tableView.dataSource is FilterRegionsDataSource) {
                filterDataSourse.assign(tableView: tableView)
            }
            filterDataSourse.filterRegions(searchText: text)
            tableView.reloadData()
        } else {
            dataSource.assign(tableView: tableView, alphabetView: nil)
        }
    }

    func load() {
        provider.load(target: .getRegions(regionId: "1", maxLevelCount: 3), completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.setupDataSource(regions: response.regions)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func close() {
        raise(event: OnboardingEvent.back)
    }
}
