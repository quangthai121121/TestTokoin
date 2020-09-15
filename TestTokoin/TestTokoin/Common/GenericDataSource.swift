//
//  GenericDataSource.swift
//  TestTokoin
//
//  Created by THAI LE QUANG on 9/14/20.
//  Copyright © 2020 Dream. All rights reserved.
//

import Foundation

class GenericDataSource<T> : NSObject {
    var data: Dynamic<[T]> = Dynamic([])
}
