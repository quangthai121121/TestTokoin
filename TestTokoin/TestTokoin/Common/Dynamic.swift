//
//  Dynamic.swift
//  TestTokoin
//
//  Created by THAI LE QUANG on 9/14/20.
//  Copyright © 2020 Dream. All rights reserved.
//

import UIKit

class Dynamic<T>: NSObject {
    typealias Listener = (T) -> ()
    var listener: Listener?
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
}
