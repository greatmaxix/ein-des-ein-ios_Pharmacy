//
//  OrderServiceViewController.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 23.02.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import UIKit

protocol OrderServiceVControllerOutput: OrderServiceViewModelInput {}
protocol OrderServiceVControllerInput: OrderServiceViewModelModelOutput {}

class OrderServiceViewController: UIViewController {
    
    @IBOutlet private var nameTextFieldView: UIView!
    @IBOutlet private var phoneTextFieldView: UIView!
    @IBOutlet private var emailTextFieldView: UIView!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var genelPriceView: UIView!
    @IBOutlet private var payButton: UIButton!
    @IBOutlet private var promocodView: UIView!
    @IBOutlet private var paymentView: UIView!
    @IBOutlet private var commentTextField: UITextView!
    @IBOutlet private var clinicView: UIView!
    @IBOutlet private var timeView: UIView!
    @IBOutlet private var generalPriceView: UIView!
    @IBOutlet private var infoClinicView: UIView!
    @IBOutlet private var tableHeight: NSLayoutConstraint!
    
    var model: OrderServiceVControllerOutput!

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setup(to: phoneTextFieldView)
        setup(to: emailTextFieldView)
        setup(to: nameTextFieldView)
        setupTableView()
        model.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTitle()
    }
    
    private func configUI() {
        tableView.separatorStyle = .none
        clinicView.layer.cornerRadius = 6
        paymentView.layer.cornerRadius = 6
        infoClinicView.layer.cornerRadius = 6
        timeView.layer.cornerRadius = 6
        configure(to: clinicView)
        configure(to: paymentView)
        configure(to: infoClinicView)
        configure(to: timeView)
        setupView()
    }
    private func setup(to textFieldView: UIView) {
        textFieldView.layer.borderWidth = 1
        textFieldView.layer.cornerRadius = 12
        textFieldView.layer.borderColor = UIColor(red: 0.145, green: 0.4, blue: 0.976, alpha: 1).cgColor
    }
    
    private func configure(to view: UIView) {
        view.layer.cornerRadius = 6
    }
    
    private func setupView() {
        commentTextField.layer.cornerRadius = 8
        commentTextField.layer.borderWidth = 1
        commentTextField.layer.borderColor = UIColor(red: 0.859, green: 0.882, blue: 0.922, alpha: 1).cgColor
        generalPriceView.layer.cornerRadius = 8
        promocodView.layer.cornerRadius = 16
        payButton.layer.cornerRadius = 16
    }
    
    private func setupTitle() {
        if let bar = self.navigationController?.navigationBar as? SimpleWithSearchNavigationBar {
            bar.title = "Оформление"
            bar.style = .normal
            bar.barDelegate = self
        }
    }
}
extension OrderServiceViewController {
    private func setupTableView() {
        
    }
}

extension OrderServiceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(at: indexPath, cellType: PaymantCell.self)
        return  cell
    }
}

extension OrderServiceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.didSelectCell(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension OrderServiceViewController: SimpleWithSearchNavigationBarDelegate {
    
    func leftBarItemAction() {
        model.close()
    }
    
    func rightBarItemAction() {
        
    }
}

extension OrderServiceViewController: OrderServiceViewModelModelOutput {
    
    func didLoad(models: [LaboratoryDetailModel]) {
        tableHeight.constant = CGFloat(3) * model.cellHeight
    }
    
    func didFetchError(error: Error) {
        
    }
}
