//
//  UIDate.swift
//  TestTokoin
//
//  Created by THAI LE QUANG on 9/15/20.
//  Copyright © 2020 Dream. All rights reserved.
//

import Foundation

extension Date {
    
    func toString(format: String = "yyyy-dd-MM") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
