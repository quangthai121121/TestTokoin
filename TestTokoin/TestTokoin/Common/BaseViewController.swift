//
//  BaseViewController.swift
//  TestTokoin
//
//  Created by THAI LE QUANG on 9/14/20.
//  Copyright © 2020 Dream. All rights reserved.
//

import UIKit
import SVProgressHUD

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showLoader(){
        self.view.backgroundColor?.withAlphaComponent(0.2)
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
    }
    
    func hideLoader(){
        self.view.backgroundColor?.withAlphaComponent(1.0)
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
}
