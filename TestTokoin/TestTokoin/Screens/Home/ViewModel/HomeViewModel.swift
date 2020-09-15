//
//  HomeViewModel.swift
//  TestTokoin
//
//  Created by THAI LE QUANG on 9/14/20.
//  Copyright © 2020 Dream. All rights reserved.
//

import Alamofire
import Foundation

protocol HomeViewModel {
    var setting: SettingModel { get set }
    
    var apiClient: APIClientProtocol {  get }
    var dataSource: Dynamic<[Article]> { get }
    
    var onError: ((String) -> ())? { get set }
    var setupLoader: ((Bool) -> ())? { get set}
    
    var showLoader: Bool { get set }
    var errorMessage: String { get set }
    
    func getArticleAt(index: Int) -> Article?
    
    var hasNextPage: Bool { get }
    
    func fetchFirstPage()
    func fetchNextPage()
}

class HomeViewModelImplement: NSObject, HomeViewModel {
    
    // MARK: - Variables
    var setting: SettingModel
    
    let apiClient: APIClientProtocol
    let dataSource: Dynamic<[Article]>
    
    var onError: ((String) -> ())?
    var setupLoader: ((Bool) -> ())?
    
    var showLoader: Bool = false {
        didSet {
            setupLoader?(showLoader)
        }
    }
    
    var errorMessage: String = "" {
        didSet {
            onError?(errorMessage)
        }
    }
    
    private var totalPage: Int {
        get {
            let page = self.totalRessult / PageSize_API
            return self.totalRessult % PageSize_API == 0 ? page : page + 1
        }
    }
    
    private var currentPage: Int
    var hasNextPage: Bool {
        get {
            return currentPage < totalPage
        }
    }
    
    private var totalRessult = 0
    
    init(setting: SettingModel, apiClient: APIClientProtocol = APIClient(), dataSource: Dynamic<[Article]>) {
        self.setting = setting
        self.apiClient = apiClient
        self.showLoader = false
        self.errorMessage = ""
        self.currentPage = 1
        self.dataSource = dataSource
        
        super.init()
        subscribeToNotifications()
    }
    
    deinit {
        unsubscribeFromNotifications()
    }
    
    func getArticleAt(index: Int) -> Article? {
        if index < dataSource.value.count {
            return dataSource.value[index]
        }
        
        return nil
    }
    
    func fetchFirstPage() {
        fetchArticle(at: 1)
    }
    
    func fetchNextPage() {
        self.currentPage += 1
        fetchArticle(at: self.currentPage)
    }
    
    func fetchArticle(at page: Int) {
        let request = APIRouter.artile(query: self.setting.keyword, date: self.setting.fromDate.toString(), page: page)
        
        showLoader = true
        
        apiClient.performRequest(route: request) { [weak self](response: DataResponse<ListArticle, AFError>) in
            self?.showLoader = false
            
            switch (response.result) {
            case .success(let list):
                if page == 1 {
                    self?.resetData()
                    self?.totalRessult = list.totalResults
                }
                
                if list.status == "error" {
                    self?.errorMessage = list.message
                    self?.currentPage = self?.totalPage ?? 0
                } else {
                    self?.dataSource.value.append(contentsOf: list.articles ?? [])
                }
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
        
    }
    
    // MARK: - Private funtions
    private func resetData() {
        self.dataSource.value.removeAll()
        self.currentPage = 1
    }
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(settingDidChangeNotification(_:)),
                                               name: NSNotification.Name(rawValue: SettingNotifications.SettingChange),
                                               object: nil)
    }
    
    private func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func settingDidChangeNotification(_ notification: NSNotification){
        self.fetchFirstPage()
    }
}
