//
//  ProfileViewController.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 16.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

final class ProfileViewController: UIViewController {

    private var cellsData: [BaseCellData] = []
    
    @IBOutlet private weak var tableView: UITableView!
    
    var model: ProfileModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        tableView.register(UINib(nibName: String(describing: NameTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: NameTableViewCell.self))
        tableView.register(EmptyTableViewCell.self, forCellReuseIdentifier: String(describing: EmptyTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: ProfileTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ProfileTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: ProfileOptionsCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ProfileOptionsCell.self))
        setupUI()
    }
    
    func setupUI() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let bar = navigationController?.navigationBar as? SimpleNavigationBar {
            bar.title = R.string.localize.profileTitle()
            bar.isLeftItemHidden = true
            bar.isRightItemHidden = true
        }
        model.loadUser { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellData: BaseCellData = model.cellDataAt(index: indexPath.row)
        if let cell: BaseTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellData.nibName!, for: indexPath) as? BaseTableViewCell {
            cell.setup(cellData: cellData)
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return model.cellDataAt(index: indexPath.row).cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.selectActionAt(index: indexPath.row)?()
    }
}
