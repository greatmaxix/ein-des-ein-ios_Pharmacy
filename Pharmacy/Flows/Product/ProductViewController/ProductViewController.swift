//
//  ProductViewController.swift
//  Pharmacy
//
//  Created by Anton Bal’ on 13.08.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol ProductViewControllerInput: ProductModelOutput {}
protocol ProductViewControllerOutput: ProductModelInput {}

final class ProductViewController: UIViewController, NavigationBarStyled {
    
    private enum GUI {
        static let cornerRadius: CGFloat = 8
        static let contentInset = UIEdgeInsets.only(top: 16, bottom: 137)
        static let separatorInset = UIEdgeInsets.only(left: 16, right: 16)
        static let separatorColor = R.color.applyBlueGray()?.withAlphaComponent(0.2)
    }
    
    private lazy var activityIndicator: MBProgressHUD = {
        let hud = MBProgressHUD(view: view)
        hud.backgroundView.style = .solidColor
        hud.backgroundView.color = UIColor.black.withAlphaComponent(0.2)
        hud.removeFromSuperViewOnHide = false
        view.addSubview(hud)
        
        return hud
    }()
    
    @IBOutlet weak var findButton: UIButton!
    
    @IBOutlet private weak var productContainerView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var bottomView: UIView!
    
    var style: NavigationBarStyle { .normalWithoutSearch }
    
    private var pageController: UIPageViewController? {
        return children.first as? UIPageViewController
    }
    
    var additionalViews: [UIView] {
        let button = UIButton(type: .custom)
        button.setImage(R.image.share(), for: .normal)
        return [button]
    }
    
    var model: ProductViewControllerOutput!
    
    var viewControllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.show(animated: true)
        configUI()
        model.load()
    }
    
    // MARK: - Private
    
    private func configUI() {
        title = model.title
        
        productContainerView.clipsToBounds = true
        productContainerView.layer.cornerRadius = GUI.cornerRadius
        tableView.delegate = self
        tableView.contentInset = GUI.contentInset
        tableView.separatorInset = GUI.separatorInset
        tableView.separatorColor = GUI.separatorColor
        
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomView.layer.cornerRadius = GUI.cornerRadius
        bottomView.bottomViewDropGrayShadow()
        findButton.buttonDropBlueShadow()
        
        pageController?.dataSource = self
        pageController?.delegate = self
        pageControl.numberOfPages = viewControllers.count
        
        tableView.tableFooterView = nil
        tableView.tableHeaderView = productContainerView
    }
    
    // MARK: - Actions
    
    @IBAction func wishListAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            model.addToWishList()
        } else {
            model.removeFromWishList()
        }
        
    }
    
    @IBAction func findAction(_ sender: UIButton) {
        model.openMap()
    }
}

// MARK: - ProductViewControllerInput

extension ProductViewController: ProductViewControllerInput {
    
    func addRemoveFromFavoriteError() {
        self.likeButton.isSelected.toggle()
    }
    
    func didLoad(product: Product) {
        viewControllers = product.imageURLs.count == 0 ? [ProductPageViewController.createWith(image: R.image.medicineImagePlaceholder()!, title: "")] : product.imageURLs.map {ProductPageViewController.createWith(url: $0, title: "")}
        pageController?.setViewControllers([viewControllers[0]], direction: .forward, animated: true, completion: nil)
        pageControl.numberOfPages = viewControllers.count
        model.dataSource.assign(tableView: tableView)
        tableView.reloadData()
        activityIndicator.hide(animated: true)
    }
}

// MARK: - UITableViewDelegate

extension ProductViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        model.didSelectCell(at: indexPath)
    }
}

// MARK: - UIPageViewControllerDelegate

extension ProductViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let currentVC =  pageViewController.viewControllers?.first,
            let currentIndex = viewControllers.firstIndex(of: currentVC) else { return }
        
        pageControl.currentPage = currentIndex
    }
}

// MARK: - UIPageViewControllerDataSource

extension ProductViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllers.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0,
            viewControllers.count > previousIndex else { return nil   }
        
        return viewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllers.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewviewControllersCount = viewControllers.count
        
        guard orderedViewviewControllersCount != nextIndex,
            orderedViewviewControllersCount > nextIndex else { return nil }
        
        return viewControllers[nextIndex]
    }
}
