//
//  ChooseClinicViewController.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 28.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit
import EventsTree

class ChooseClinicViewController: UIViewController, NavigationBarStyled {
    
    var style: NavigationBarStyle = .normalWithoutSearch
    
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var containerMap: UIView!
    @IBOutlet private weak var containerList: UIView!
    
    var clinicModel: ClinicListModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        scrollView.delegate = self
        
        segmentControl.setTitle(R.string.localize.analisisChoseClinickList(), forSegmentAt: 0)
        segmentControl.setTitle(R.string.localize.analisisChoseClinickMap(), forSegmentAt: 1)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: R.font.openSansSemiBold(size: 14)!, NSAttributedString.Key.foregroundColor: R.color.welcomeBlue()!], for: .selected)
        
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: R.font.openSansSemiBold(size: 14)!, NSAttributedString.Key.foregroundColor: R.color.gray()!], for: .normal)
        
        configureChildren()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = R.string.localize.analisisTitleChoseClinick()
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
        if let listVC = self.children.first(where: { $0 is ClinicsListController }) as? ClinicsListController {
            self.clinicModel.output = listVC
            listVC.model = clinicModel
        }
        
        if let mapVC = self.children.first(where: { $0 is MapViewController }) {
            debugPrint(mapVC)
        }
    }
}

extension ChooseClinicViewController: UIScrollViewDelegate {
    
}
