//
//  Reusable.swift
//  TestTokoin
//
//  Created by THAI LE QUANG on 9/14/20.
//  Copyright © 2020 Dream. All rights reserved.
//

import UIKit

protocol ResuableViews {
    static var reuseIdentifier: String { get }
}

extension ResuableViews where Self: UIView {
    static var reuseIdentifier: String {
        return NSStringFromClass(self)
    }
}


protocol NibLoadableView: class {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}
