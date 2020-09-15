//
//  HomeDetailViewModel.swift
//  TestTokoin
//
//  Created by THAI LE QUANG on 9/15/20.
//  Copyright © 2020 Dream. All rights reserved.
//

import UIKit

protocol HomeDetailViewModel {
    var article: Dynamic<Article> { get }
}

class HomeDetailViewModelImplement: NSObject, HomeDetailViewModel {
    
    let article: Dynamic<Article>
    
    init(withArticle article: Article) {
        self.article = Dynamic(article)
        
        super.init()
    }
}
