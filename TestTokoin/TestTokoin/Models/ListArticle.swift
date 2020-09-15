//
//  ListArticle.swift
//  TestTokoin
//
//  Created by THAI LE QUANG on 9/15/20.
//  Copyright © 2020 Dream. All rights reserved.
//

import Foundation

struct ListArticle : Codable {
    
    var status: String = ""
    var message: String = ""
    var totalResults: Int = 0
    var articles : [Article]?

    enum CodingKeys: String, CodingKey {
        case totalResults = "totalResults"
        case articles = "articles"
        case status = "status"
        case message = "message"
    }
    
    init(){
        
    }
    
    init(articles : [Article]){
        self.articles = articles
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults) ?? 0
        articles = try values.decodeIfPresent([Article].self, forKey: .articles)
        status = try values.decodeIfPresent(String.self, forKey: .status) ?? ""
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
    }
}

