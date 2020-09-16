//
//  HomeViewModelTests.swift
//  TestTokoinTests
//
//  Created by THAI LE QUANG on 9/15/20.
//  Copyright © 2020 Dream. All rights reserved.
//

import Alamofire
@testable import TestTokoin
import XCTest

class HomeViewModelTests: XCTestCase {

    // MARK :-  Variables
    var viewModel: HomeViewModel!
    var vc: HomeViewController!
    var dataSource: Dynamic<[Article]>!
    var mockApiClient: MockAPIClient!
    
    // Life cycle
    override func setUp() {
        super.setUp()
        
        let setting = SettingModel(keyword: "Bitcoin", fromDate: Date())
        // Initializing properties
        dataSource = Dynamic<[Article]>([])
        viewModel = HomeViewModelImplement(setting: setting, dataSource: dataSource)
        vc = HomeViewController()
        mockApiClient = MockAPIClient()
    }
    
    // Life cycle
    
    override func tearDown() {
        // Deinitializing propertise
        viewModel = nil
        vc = nil
        dataSource = nil
        mockApiClient = nil
        
        super.tearDown()
    }
    
    // Testing fetch articles list method is calling properly
    // Expectation is onError or datasourse observer is called
    
    func testFetchArticlesListCalled() {
        let expectation = XCTestExpectation(description: "Articles List fetch")
        
        viewModel.onError = { _ in
           expectation.fulfill()
        }
        
        viewModel.dataSource.bindAndFire { (list) in
            expectation.fulfill()
        }
        
        viewModel.fetchFirstPage()
        wait(for: [expectation], timeout: 5.0)
    }
    
    //Test case for testing activity loader working
    // expectation is will show and hide loading and functions are called properly
    
    func testActivityLoaderShowing() {
        let expectation = XCTestExpectation(description: "Articles List fetch")
        viewModel.setupLoader = {(loader) in
            if loader {
                expectation.fulfill()
            }else{
                expectation.fulfill()
            }
        }
    
        viewModel.fetchFirstPage()
        wait(for: [expectation], timeout: 5.0)
    }
}

class MockAPIClient: APIClientProtocol {
    
    var sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = HTTPHeaders.default.dictionary
            configuration.timeoutIntervalForRequest = TimeInterval(60)
            configuration.timeoutIntervalForResource = TimeInterval(60)
            configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadRevalidatingCacheData
            configuration.httpCookieStorage = nil
            
            var trustedPolicy: ServerTrustManager?
        
            let sessionManager = Session(configuration: configuration, serverTrustManager: trustedPolicy)
            
            return sessionManager
    }()
    
    var vehicleModel : ListArticle?
    
    func performRequest<T>(route: APIRouter, completionHandler: @escaping (DataResponse<T, AFError>) -> ()) where T : Decodable {
        sessionManager.request(route).responseDecodable { (response) in
            completionHandler(response)
        }
    }    
}
