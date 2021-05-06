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
    @IBOutlet var height: NSLayoutConstraint!
    
    var model: QuestionViewControllerOutput!
    var style: NavigationBarStyle = .normalWithoutSearch
    
    override func viewDidLoad() {
        super.viewDidLoad()

        model.load()
        setupTableView()
        
    }

    
    func makeAPhoneCall()  {
        let url: NSURL = URL(string: "TEL://1234567890")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }


    private func setupUI() {
        if let bar = navigationController?.navigationBar as? SimpleNavigationBar {
            bar.barDelegate = self
            bar.title = R.string.localize.any_question.localized()
            bar.isLeftItemHidden = false
        }
    }
}

extension QuestionViewController {
    private func setupTableView() {
        tableView.register(UINib(resource: R.nib.questionCell),
                           forCellReuseIdentifier: String(describing: QuestionCell.self))
        tableView.register(UINib(resource: R.nib.callCell),
                           forCellReuseIdentifier: String(describing: CallCell.self))
    }
}

extension QuestionViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return model.models.count
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(at: indexPath, cellType: QuestionCell.self)
            let model = self.model.models[indexPath.row]
            cell.apply(model: model, isHidden: !(self.model.selectedModel?.name == model.name))
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(at: indexPath, cellType: CallCell.self)
            cell.fill()
            
            return cell
        default:
            return UITableViewCell()
        }
        

    }
}

extension QuestionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            model.didSelectCell(at: indexPath)
            tableView.reloadData()
            tableView.deselectRow(at: indexPath, animated: true)
        case 1:
            print("dskfhksdh")
            let phoneNumber: String = "telprompt://" + "+380679264663"
            let url = URL(string: phoneNumber)!
      
            UIApplication.shared.open(url, options: [:])
        
        default:
            break
        }
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
