//
//  TabCoordinator.swift
//  KyivPost
//
//  Created by Mikhail Timoscenko on 22.06.2020.
//  Copyright © 2020 KyivPost. All rights reserved.
//

import Foundation
import UIKit

public struct TabBarItemInfo {

  public let title: String?
  public let icon: UIImage?
  public let highlightedIcon: UIImage?

  public init(title: String?, icon: UIImage?, highlightedIcon: UIImage?) {
    self.title = title
    self.icon = icon
    self.highlightedIcon = highlightedIcon
  }

}

public protocol TabBarEmbedCoordinable: Coordinator {

  var tabItemInfo: TabBarItemInfo { get }
  
}

public extension TabBarEmbedCoordinable {
  
  func tabItem() -> UITabBarItem {
    return UITabBarItem(
      title: tabItemInfo.title,
      image: tabItemInfo.icon,
      selectedImage: tabItemInfo.highlightedIcon
    )
  }
}
