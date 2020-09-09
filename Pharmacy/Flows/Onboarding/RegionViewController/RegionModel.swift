//
//  RegionModel.swift
//  Pharmacy
//
//  Created by CGI-Kite on 04.09.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import EventsTree
import CoreLocation

protocol RegionInput: class {
    var dataSource: RegionsDataSource { get }
    var title: String { get }
    func load()
    func close()
    func startLocationTracking()
    func openAuthSlide()
    func filterRegions(searchText: String)
}

protocol RegionOutput: class {
    func reloadRegions()
}

final class RegionModel: EventNode {
    
    private var regionDataSource: RegionsDataSource = RegionsDataSource()
    private let provider = DataManager<LocationAPI, RegionResponse>()
    private var locationService = LocationService()
    private var allRegions: [Region] = []
    unowned var output: RegionOutput!
    
    private func setupDataSource(regions: [Region]) {
        
        if let subRegions: [Region] = regions.first?.subRegions {
            allRegions = []
            subRegions.forEach({
                if let regions = $0.subRegions {
                    allRegions.append(contentsOf: regions)
                }
            })
            
            allRegions.sort(by: { reg1, reg2 in
                reg1.name < reg2.name
            })
            
            updateSections(searchText: "")

            regionDataSource.selectRegionClosure = { [weak self] selectedRegion in
                self?.saveRegion(region: selectedRegion)
            }
            output.reloadRegions()
            
            locationService.firstLocationUpdate = { [weak self] coordinate in
                self?.saveRegion(coordinate: coordinate)
            }
        }
    }
    
    private func updateSections(searchText: String) {
        
        var alphabetCharacters: [Character] = []
        var sections: [RegionSection] = []
        var section: RegionSection = RegionSection()

        if var firstCharacter: Character = allRegions[0].name.first, searchText == "" {
            for region in allRegions {
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
        } else {
            
            let regions = allRegions.filter({$0.name.lowercased().contains(searchText)})
            section.regions = regions
            section.title = searchText
            sections.append(section)
        }
        
        regionDataSource.update(sections: sections, alphabetCharacters: alphabetCharacters)
    }
    
    func saveRegion(region: Region) {
        UserDefaultsAccessor.write(value: region.regionId, for: \.regionId)
        openAuthSlide()
    }
    
    func saveRegion(coordinate: CLLocationCoordinate2D) {
        openAuthSlide()
    }
}

extension RegionModel: RegionInput {
    
    var title: String {
        return R.string.localize.regionTitle()
    }
    
    var dataSource: RegionsDataSource {
        return regionDataSource
    }

    func load() {
        provider.load(target: .getRegions(regionId: nil, maxLevelCount: nil), completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.setupDataSource(regions: response.regions)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func filterRegions(searchText: String) {
        updateSections(searchText: searchText)
    }
    
    func openAuthSlide() {
        raise(event: OnboardingEvent.regionSelected)
    }
    
    func startLocationTracking() {
        locationService.updateCurrentLocation()
    }
    
    func close() {
        raise(event: OnboardingEvent.closeRegion)
    }
}
