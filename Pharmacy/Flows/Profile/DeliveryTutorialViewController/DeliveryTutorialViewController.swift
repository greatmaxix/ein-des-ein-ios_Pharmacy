//
//  DeliveryTutorialViewController.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 10.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit
import EventsTree

class DeliveryTutorialViewController: UIViewController, NavigationBarStyled {
    
    var style: NavigationBarStyle = .normalWithoutSearch
    
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var containerMap: UIView!
    @IBOutlet private weak var containerList: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        scrollView.delegate = self

        segmentControl.setTitle(R.string.localize.order_delivary_own.localized(), forSegmentAt: 0)
        segmentControl.setTitle(R.string.localize.order_delivary.localized(), forSegmentAt: 1)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: R.font.openSansSemiBold(size: 14)!, NSAttributedString.Key.foregroundColor: R.color.welcomeBlue()!], for: .selected)
        
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: R.font.openSansSemiBold(size: 14)!, NSAttributedString.Key.foregroundColor: R.color.gray()!], for: .normal)
        
        configureChildren()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let bar = self.navigationController?.navigationBar as? SimpleNavigationBar {
            bar.title = R.string.localize.how_to_order.localized()
            
            bar.isLeftItemHidden = false
            bar.barDelegate = self
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            self.scrollView.setContentOffset(.init(x: self.view.frame.width, y: 0), animated: true)
        }
        
        if sender.selectedSegmentIndex == 0 {
            self.scrollView.setContentOffset(.init(x: 0, y: 0), animated: true)
        }
    }
    
    func configureChildren() {
//        if let listVC = self.children.first(where: { $0 is ClinicsListController }) {
//            debugPrint(listVC)
//        }
//
//        if let mapVC = self.children.first(where: { $0 is MapViewController }) {
//            debugPrint(mapVC)
//        }
    }
}

extension DeliveryTutorialViewController: UIScrollViewDelegate {
    
}

extension DeliveryTutorialViewController: SimpleNavigationBarDelegate {
    func leftBarItemAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func rightBarItemAction() {
        
    }
}
