//
//  UIViewController.swift
//  TestTokoin
//
//  Created by THAI LE QUANG on 9/14/20.
//  Copyright © 2020 Dream. All rights reserved.
//

import UIKit
import SVProgressHUD

extension UIViewController {
    
    func showAlertWith(message: String, title: String = "", completion: ((UIAlertAction) -> Void)? =  nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: completion)
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: Storyboard extension
public protocol StoryboardProtocol {
    static func bundle() -> Bundle?
    static func storyboardName() -> String
}

public extension StoryboardProtocol where Self: UIViewController {
    static func identifier() -> String {
        return "\(self)"
    }
    
    static func controllerFromStoryboard() -> Self? {
        let storyboard = UIStoryboard(name: self.storyboardName(), bundle: self.bundle())
        return storyboard.instantiateViewController(withIdentifier: self.identifier()) as? Self
    }
    
    static func controllerFromStoryboard(storyboardName: String) -> Self? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: self.bundle())
        return storyboard.instantiateViewController(withIdentifier: self.identifier()) as? Self
    }
}
