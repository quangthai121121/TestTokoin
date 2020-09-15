//
//  SettingViewModel.swift
//  TestTokoin
//
//  Created by THAI LE QUANG on 9/15/20.
//  Copyright © 2020 Dream. All rights reserved.
//

import Foundation

enum SettingNotifications {
    static let SettingChange = "SettingChange"
}

protocol SettingViewModel {
    var settingModel: Dynamic<SettingModel> { get }
    
    func updateKeyword(keyword: String)
    func updateFromDate(date: Date)
}


class SettingViewModelSetting: NSObject, SettingViewModel {
    
    // MARK: - Variables
    let settingModel: Dynamic<SettingModel>
    
    init(withKeyword keyword: String, fromDate: Date) {
        self.settingModel = Dynamic(SettingModel(keyword: keyword, fromDate: fromDate))
        
        super.init()
    }
    
    func updateKeyword(keyword: String) {
        if keyword == self.settingModel.value.keyword { return }
        self.settingModel.value.keyword = keyword
        NotificationCenter.default.post(name: Notification.Name(rawValue: SettingNotifications.SettingChange), object: self)
    }
    
    func updateFromDate(date: Date) {
        if date == self.settingModel.value.fromDate { return }
        self.settingModel.value.fromDate = date
        NotificationCenter.default.post(name: Notification.Name(rawValue: SettingNotifications.SettingChange), object: self)
    }
}
