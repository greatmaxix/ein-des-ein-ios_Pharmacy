//
//  AboutAppModel.swift
//  Pharmacy
//
//  Created by Ekateryna Maslova on 28.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import Moya
import EventsTree

enum AboutAppEvent: Event {
  case close
  case openTerms
  case openData
  case openCondition
  case openCashback
}

protocol AboutAppInput: class {
  var cellCount: Int { get }
  func selectActionAt(index: Int) -> EmptyClosure?
  func cellDataAt(index: Int) -> BaseCellData
  func close()
}

final class AboutAppModel: EventNode {
  
  private var cellsData: [BaseCellData] = []
  unowned var output: AboutAppOutput!
  
  override init(parent: EventNode?) {
    super.init(parent: parent)
    
    setupDataSource()
  }
  
  // MARK: - Private functions
  private func setupDataSource() {
    
    let openOptionHandler: ((_: AboutAppEvent) -> Void) = { [weak self] event in
      self?.raise(event: event)
    }
    
    cellsData = []
    
    do {
      let cellData: AboutAppTableViewCellData = AboutAppTableViewCellData(title: R.string.localize.aboutTerms.localized())
      cellData.image = R.image.user()
      cellData.selectHandler = { [weak self] in
        self?.raise(event: AppEvent.presentInDev(nil))
//        self?.raise(event: AppEvent.openTerms)
      }
      cellsData.append(cellData)
    }
    do {
      let cellData: AboutAppTableViewCellData = AboutAppTableViewCellData(title: R.string.localize.aboutData.localized())
      cellData.image = R.image.lock()
      cellData.selectHandler = { [weak self] in
        self?.raise(event: AppEvent.presentInDev(nil))
//        self?.raise(event: AppEvent.openData)
      }
      cellsData.append(cellData)
    }
    do {
      let cellData: AboutAppTableViewCellData = AboutAppTableViewCellData(title: R.string.localize.aboutCondition.localized())
      cellData.image = R.image.shield()
      cellData.selectHandler = { [weak self] in
        self?.raise(event: AppEvent.presentInDev(nil))
//        self?.raise(event: AppEvent.openCondition)
      }
      cellsData.append(cellData)
    }
    do {
      let cellData: AboutAppTableViewCellData = AboutAppTableViewCellData(title: R.string.localize.aboutCashback.localized())
      cellData.image = R.image.dollar()
      cellData.selectHandler = { [weak self] in
        self?.raise(event: AppEvent.presentInDev(nil))
//        self?.raise(event: AppEvent.openCashback)
      }
      cellsData.append(cellData)
    }
  }
}

// MARK: - AboutAppInput
extension AboutAppModel: AboutAppInput {
  var cellCount: Int {
      return cellsData.count
  }
  
  func cellDataAt(index: Int) -> BaseCellData {
      return cellsData[index]
  }
  
  func selectActionAt(index: Int) -> EmptyClosure? {
      cellsData[index].selectHandler
  }
  
  func close() {
    raise(event: AboutAppEvent.close)
  }
}
