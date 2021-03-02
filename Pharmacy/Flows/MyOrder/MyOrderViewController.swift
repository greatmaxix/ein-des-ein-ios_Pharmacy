//
//  File.swift
//  Pharmacy
//
//  Created by Anna Yatsun on 01.03.2021.
//  Copyright © 2021 pharmacy. All rights reserved.
//
import UIKit


protocol MyOrderViewControllerInput: MyOrderModelOutput {}
protocol MyOrderViewControllerOutput: MyOrderModelInput {}

class MyOrderViewController: UIViewController, NavigationBarStyled {
    
    var style: NavigationBarStyle = .normalWithSearch
    
    @IBOutlet private var tableView: UITableView!
    var model: MyOrderViewControllerOutput!

    var types: [TypeOfAnalysis] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // model.load()
        configUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }

    func configUI() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupUI() {
        if let bar = self.navigationController?.navigationBar as? SimpleWithSearchNavigationBar {
            bar.barDelegate = self
            bar.style = style
            bar.title =  "Биохимические"
            bar.isLeftItemHidden = false
            bar.leftItemTitle = nil
        }
    }
}

// MARK: - Private methods
extension MyOrderViewController {
    
    private func setupTableView() {
        tableView.register(UINib(resource: R.nib.typeOfAnalysisCell),
                           forCellReuseIdentifier: String(describing: MyOrderTableViewCell.self))
        
    }
}

extension MyOrderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(at: indexPath, cellType: MyOrderTableViewCell.self)
        cell.apply()
//        let model = self.types[indexPath.row]
       // cell.apply(analisName: model.)
//
        return cell
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension MyOrderViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
}


// MARK: - UITableViewDelegate
extension MyOrderViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //model.didSelectCell(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - AnalysisAndDiagnosticsControllerInput
extension MyOrderViewController: MyOrderViewControllerInput {
    
    func didLoad(models: [TypeOfAnalysis]) {
        self.types = models
    }
    
    func didFetchError(error: Error) {
        
    }
}

extension MyOrderViewController: SimpleWithSearchNavigationBarDelegate {
    
    func leftBarItemAction() {
        if let bar = self.navigationController?.navigationBar as? SimpleWithSearchNavigationBar {
            bar.setupUI()
        }
        
        //model.close()
    }
    
    func rightBarItemAction() {
        
    }
}
