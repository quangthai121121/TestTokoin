//
//  APIClientProtocol.swift
//  TestTokoin
//
//  Created by THAI LE QUANG on 9/14/20.
//  Copyright © 2020 Dream. All rights reserved.
//

import Foundation
import Alamofire

/// Enum for Network failures with error messages

enum APIError: String, Error{
    case requestError  = "Request failed"
    case networkError  = "Network failure"
    case responseError = "Response error"
    case parsingError  = "Failed to parse JSON"
}

// Generic Rescult object with both .success and .failure
// - parameter T: class or struct of Codable type on .success
// - parameter U: error of any type on .failure
enum Result<T : Codable, U: Error> {
    case success(data: T)
    case failure(U?)
}

protocol APIClientProtocol : class{
    
    var sessionManager: Session { get set }
    
    func performRequest<T: Decodable>(route: APIRouter, completionHandler: @escaping (DataResponse<T, AFError>) -> ())
}
