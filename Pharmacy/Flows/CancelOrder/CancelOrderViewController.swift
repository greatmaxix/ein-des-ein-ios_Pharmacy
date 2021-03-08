//
//  CancelOrderViewController.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 02.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

protocol CancelOrderViewControllerOutput: CancelOrderModelInput{}

protocol CancelOrderViewControllerInput: CancelOrderModelOutput {}
//a

class CancelOrderViewController: UIViewController, NavigationBarStyled {
        
    @IBOutlet var customerInfoLabel: UILabel!
    @IBOutlet var userInfoView: UIView!
    @IBOutlet var labelService: UILabel!
    @IBOutlet var viewService: UIView!
    
    @IBOutlet var clinicView: UIView!
    @IBOutlet var clinicLabel: UILabel!
    @IBOutlet var timeView: UIView!
    
    @IBOutlet var viewComment: UIView!
    @IBOutlet var comment: UILabel!
    @IBOutlet var typePaymentLabel: UILabel!
    @IBOutlet var viewPayment: UIView!
    
    @IBOutlet var viewCell: UIView!
    @IBOutlet var totalView: UIView!
    @IBOutlet var cncelButton: UIButton!
    @IBOutlet var viewPromo: UIView!
    
    var style: NavigationBarStyle = .normal
    
    var model: CancelOrderViewControllerOutput!
    private var models: [LaboratoryResearchModel] = []
    
    @IBOutlet private var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        //model.load()
        self.corfigureView(view: userInfoView)
        self.corfigureView(view: viewService)
        self.corfigureView(view: clinicView)
        self.corfigureView(view: timeView)
        self.corfigureView(view: viewPayment)
        self.corfigureView(view: viewComment)
        self.corfigureView(view: cellInfoView)
        self.configure()
    }
    
    @IBOutlet var cellInfoView: UIView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTitle()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        model.close()
    }
    
    private func setupTitle() {
        if let bar = navigationController?.navigationBar as? SimpleNavigationBar {
            bar.barDelegate = self
            bar.title = "№ 12583"
            bar.isLeftItemHidden = false
        }
    }
    
    func configure() {
//        UserDefaults.
        self.cncelButton.layer.borderWidth = 1
        self.cncelButton.layer.borderColor = UIColor(red: 0.145, green: 0.4, blue: 0.976, alpha: 1).cgColor
        self.cncelButton.layer.cornerRadius = 20
        self.viewComment.backgroundColor = UIColor(red: 0.145, green: 0.4, blue: 0.976, alpha: 0.2)
        

    }
    func corfigureView(view: UIView) {
        view.layer.cornerRadius = 10
    }
}


extension CancelOrderViewController {
    private func setupTableView() {
        self.tableView?.register(UINib(resource: R.nib.laboratoryTableViewCell),
                           forCellReuseIdentifier: String(describing: LaboratoryTableViewCell.self))
    }
}




// MARK: - AnalysisAndDiagnosticsControllerInput
extension CancelOrderViewController: LaboratoryControllerInput {
    
    func didLoad(models: [LaboratoryResearchModel]) {
        self.models = models
    }
        
    func didFetchError(error: Error) {
        
    }
}
extension CancelOrderViewController: SimpleNavigationBarDelegate {
    
    func leftBarItemAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func rightBarItemAction() {
        
    }
}

extension CancelOrderViewController: CancelOrderModelOutput {
    
}
