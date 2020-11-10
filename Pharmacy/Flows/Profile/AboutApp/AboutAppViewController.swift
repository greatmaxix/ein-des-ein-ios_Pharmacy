//
//  AboutAppViewController.swift
//  Pharmacy
//
//  Created by Ekateryna Maslova on 28.10.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit

protocol AboutAppOutput: class {
}

final class AboutAppViewController: UIViewController {
  
  // MARK: - Outlets
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var descriptionLabel: UILabel!
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet weak var linkTextView: UITextView!
  
  var model: AboutAppInput!
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.separatorStyle = .none
    
    tableView.register(UINib(nibName: String(describing: AboutAppTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AboutAppTableViewCell.self))
  }
  
  // MARK: - Private functions
  private func setupUI() {
    /// setup view styles
    view.backgroundColor = R.color.lightGray()
    
    /// setup text
    titleLabel.text = R.string.localize.aboutTitle()
    descriptionLabel.text = R.string.localize.aboutDescription()
//    linkTextView.text = R.string.localize.aboutLink()
    
    /// setup label styles
    titleLabel.textColor = R.color.textDarkBlue()
    titleLabel.font = R.font.openSansSemiBold(size: 14)
    descriptionLabel.textColor = R.color.textDarkBlue()
    descriptionLabel.font = R.font.openSansRegular(size: 12)
    linkTextView.font = R.font.openSansRegular(size: 12)
    
    /// setup textView link
    let url = URL(string: "https://\(R.string.localize.aboutLink())")
    let attributedLinkString = NSMutableAttributedString(string: R.string.localize.aboutLink(),
                                                         attributes: [.link: url!])
    linkTextView.linkTextAttributes = [
      .foregroundColor: R.color.welcomeBlue(),
        .underlineStyle: 0
    ]
    linkTextView.attributedText = attributedLinkString
    linkTextView.isUserInteractionEnabled = true
    linkTextView.isEditable = false

    /// setup navigation bar
    setupNavBar()
  }
  
  private func setupNavBar() {
    if let bar = navigationController?.navigationBar as? SimpleNavigationBar {
      bar.isLeftItemHidden = false
      bar.isRightItemHidden = false
      bar.title = R.string.localize.aboutAbout()
      bar.leftItemTitle = R.string.localize.profileProfile()
      bar.barDelegate = self
    }
  }
}

// MARK: - SimpleNavigationBarDelegate
extension AboutAppViewController: SimpleNavigationBarDelegate {
  func leftBarItemAction() {
    model.close()
  }
  
  func rightBarItemAction() {
    
  }
}

// MARK: - UITableViewDataSource
extension AboutAppViewController: UITableViewDataSource {
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
extension AboutAppViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return model.cellDataAt(index: indexPath.row).cellHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    model.selectActionAt(index: indexPath.row)?()
  }
}

// MARK: - AboutAppOutput
extension AboutAppViewController: AboutAppOutput {
  
}
