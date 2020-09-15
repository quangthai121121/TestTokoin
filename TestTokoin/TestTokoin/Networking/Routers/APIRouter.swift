//
//  APIRouter.swift
//  TestTokoin
//
//  Created by THAI LE QUANG on 9/14/20.
//  Copyright © 2020 Dream. All rights reserved.
//

import Alamofire
import Foundation

enum APIRouter: URLRequestConvertible {
    
    case artile(query: String, date: String, page: Int)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .artile:
            return .get
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .artile(let query, let date, let page):
            return "?q=\(query)&from=\(date)&sortBy=publishedAt&apiKey=9afeea06a80140f28794ff4d1f928b34&pageSize=\(PageSize_API)&page=\(page)"
        }
    }
    
    var url: URL? {
        return URL(string: self.path)
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .artile:
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url =  "http://newsapi.org/v2/everything"

        var urlRequest = URLRequest(url:  URL(string: url.appending(path).removingPercentEncoding ?? "")!)

        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        // Common Headers
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}
