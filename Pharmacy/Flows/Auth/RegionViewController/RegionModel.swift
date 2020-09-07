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
    var title: String { get }
    func load()
}

protocol RegionOutput: class {
    func reloadRegions()
}

class RegionModel: EventNode {
    fileprivate var regionDataSource: RegionsDataSource!
    fileprivate let provider = DataManager<LocationAPI, RegionResponse>()
    unowned var output: RegionOutput!
}

extension RegionModel: RegionInput {
    var title: String {
        return R.string.localize.regionTitle()
    }
    
    var dataSource: RegionsDataSource {
        return regionDataSource
    }
    
    func load() {
        provider.load(target: .getRegions(regionId: "1", maxLevelCount: 3), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if let region = response.regions.first {
                    self.regionDataSource = RegionsDataSource(mainRegion: region)
                    self.output.reloadRegions()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}
