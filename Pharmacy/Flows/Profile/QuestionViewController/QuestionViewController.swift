//
//  QuestionViewController.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 09.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//

import Foundation

import UIKit

protocol QuestionViewControllerOutput: QuestionViewModelInput {}
protocol QuestionViewControllerInput: QuestionViewModelOutput {}

class QuestionViewController: UIViewController, NavigationBarStyled {
    
    @IBOutlet private var tableView: UITableView!
    
    @IBOutlet var callToUsView: UIView!
    @IBOutlet var height: NSLayoutConstraint!
    var model: QuestionViewControllerOutput!
    var style: NavigationBarStyle = .normalWithoutSearch
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        model.load()
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }

    private func configUI() {
        callToUsView.backgroundColor = UIColor(red: 0, green: 0.039, blue: 0.387, alpha: 1)
        callToUsView.layer.cornerRadius = 8
        
    }

    private func setupUI() {
        if let bar = navigationController?.navigationBar as? SimpleNavigationBar {
            bar.barDelegate = self
            bar.title = "Есть вопросы?"
            bar.isLeftItemHidden = false
        }
    }
}

extension QuestionViewController {
    private func setupTableView() {
        tableView.register(UINib(resource: R.nib.questionCell),
                           forCellReuseIdentifier: String(describing: QuestionCell.self))
    }
}

extension QuestionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(at: indexPath, cellType: QuestionCell.self)
        let model = self.model.models[indexPath.row]
        cell.apply(model: model)
        return cell
    }
}

extension QuestionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.didSelectCell(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension QuestionViewController: SimpleNavigationBarDelegate {
    
    func leftBarItemAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func rightBarItemAction() {
        
    }
}

extension QuestionViewController: QuestionViewModelOutput {
    func didLoad(models: [QustionModel]) {
//        self.height.constant = CGFloat(models.count) * model.cellHeight
    }
    
    
    func didFetchError(error: Error) {
        
    }
}