//
//  ArticleCell.swift
//  TestTokoin
//
//  Created by THAI LE QUANG on 9/14/20.
//  Copyright © 2020 Dream. All rights reserved.
//

import UIKit
import Kingfisher

class ArticleCell: BaseTableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbAuthor: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgView?.image = nil
        lbTitle.text = nil
        lbAuthor.text = nil
        lbDescription.text = nil
    }
    
    override func visulizeCell(model: Any) {
        guard let model = model as? Article else { return }
        
        lbTitle.text = model.title
        lbAuthor.text = model.author
        lbDescription.text = model.description
        
        
        if let urlString = model.urlToImage, let url = URL(string: urlString) {
            self.imgView.kf.setImage(with: url) { (result) in
                switch (result) {
                case .success(let image):
                    self.imgView.image = image.image
                    self.imageView?.contentMode = .scaleAspectFill
                case .failure(_):
                    print("fail: \(urlString)")
                }
            }
        }
    }
}
