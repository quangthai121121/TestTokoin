//
//  HomeDetailViewController.swift
//  TestTokoin
//
//  Created by THAI LE QUANG on 9/15/20.
//  Copyright © 2020 Dream. All rights reserved.
//

import UIKit
import Kingfisher

class HomeDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var lbAuthor: UILabel!
    @IBOutlet var tvDescription: UITextView!

    var viewModel: HomeDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Article Detail"
        fillUI()
    }
    
    fileprivate func fillUI() {
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.article.bindAndFire { [unowned self] in
            if let urlString = $0.urlToImage, let url = URL(string: urlString) {
                self.imgView.kf.setImage(with: url)
            }
            self.lbTitle.text = "Title: " + ($0.title ?? "")
            self.lbAuthor.text = "Author: " + ($0.author ?? "")
            self.tvDescription.text = ($0.description ?? "") + "\n" + ($0.url ?? "")
        }
    }
}
