//
//  HomeViewController.swift
//  TestTokoin
//
//  Created by THAI LE QUANG on 9/14/20.
//  Copyright © 2020 Dream. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Variables
    var dataSource = HomeViewDataSource([])
    private var viewModel: HomeViewModel? {
        didSet {
            fillUI()
        }
    }
    
    private let refreshControl = UIRefreshControl()
    let threshold: CGFloat = 100.0
    var isLoadingMore = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Articles"
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refreshControl
        } else {
            self.tableView.addSubview(refreshControl)
        }
        self.refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        
        let setting = SettingModel(keyword: "Bitcoin", fromDate: Date())
        viewModel = HomeViewModelImplement(setting: setting, dataSource: dataSource)
    }
    
    // MARK: - Private functions
    private func fillUI() {
        guard var viewModel = viewModel else {
            return
        }
        
        viewModel.setupLoader = { [weak self] loader in
            loader == true ? self?.showLoader() : self?.hideLoader()
        }
        
        viewModel.onError = { [weak self] message in
            self?.showAlertWith(message: message)
        }
        
        tableView.dataSource = dataSource
        viewModel.dataSource.bindAndFire { [weak self] (list) in
            
            self?.tableView.reloadData()
            self?.isLoadingMore = false
            self?.refreshControl.endRefreshing()
        }
        
        self.isLoadingMore = true
        viewModel.fetchFirstPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? HomeDetailViewController,
            let indexPath = sender as? IndexPath,
            let article = viewModel?.getArticleAt(index: indexPath.row) {
            let detailVM = HomeDetailViewModelImplement(withArticle: article)
            controller.viewModel = detailVM
        }
    }
    
    // MARK: - Actions
    @objc private func updateData() {
        viewModel?.fetchFirstPage()
    }
}

class HomeViewDataSource: Dynamic<[Article]>, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ArticleCell.self, for: indexPath)
        cell.visulizeCell(model: value[indexPath.row])
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "presentDetailFlow", sender: indexPath)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let contentOffset = scrollView.contentOffset.y
      let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;

        let hasNextPage = viewModel?.hasNextPage ?? false
        if !isLoadingMore && (maximumOffset - contentOffset <= threshold && hasNextPage) {
          self.isLoadingMore = true
        viewModel?.fetchNextPage()
      }
    }
}
