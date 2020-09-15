//
//  APIClient.swift
//  TestTokoin
//
//  Created by THAI LE QUANG on 9/14/20.
//  Copyright © 2020 Dream. All rights reserved.
//

import Foundation
import Alamofire

class APIClient : NSObject, APIClientProtocol {
    
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
    
    // APIClient protocol method performing a network request with session manager
    // This method makes a network call and parse it into a response object of Decodable type
    // - parameter T: generic object of Decodable type
    // - parameter route: request object
    // - parameter completionHandler: to receive callback after getting response
    func performRequest<T>(route: APIRouter, completionHandler: @escaping (DataResponse<T, AFError>) -> ()) where T : Decodable {
        sessionManager.request(route).responseDecodable { (response) in
            completionHandler(response)
        }
    }
}
