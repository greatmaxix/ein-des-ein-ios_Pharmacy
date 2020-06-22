//
//  Model.swift
//  Pharmacy
//
//  Created by CGI-Kite on 22.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import EventsTree

open class Model: EventNode {

  public fileprivate(set) var isActive = false

}

public protocol ControllerVisibilityOutput {

  func controllerDidBecomeVisible()
  func controllerDidBecomeHidden()

}

public extension ControllerVisibilityOutput where Self: Model {

  func controllerDidBecomeVisible() {
    isActive = true
  }

  func controllerDidBecomeHidden() {
    isActive = false
  }

}
