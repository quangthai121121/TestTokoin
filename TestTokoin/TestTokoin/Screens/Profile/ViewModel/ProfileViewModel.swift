//
//  ProfileViewModel.swift
//  TestTokoin
//
//  Created by THAI LE QUANG on 9/15/20.
//  Copyright © 2020 Dream. All rights reserved.
//

import UIKit

enum ProfileViewType {
    case login
    case register
    case profile
}

protocol ProfileViewModel {
    
    var viewType: Dynamic<ProfileViewType> { get set }
    var enableButton: Dynamic<Bool> { get }
    
    func updateUserName(inputText: String)
    func updatePassword(inputText: String)
    func updateConfirm(inputText: String)
    
    func switchLoginRegister()
    
    func performRegister()
    func performLogin()
    func performLogout()
    
    var onError: ((String) -> ())? { get set }
    var errorMessage: String { get set }
}

class ProfileViewModelImplement: NSObject, ProfileViewModel {
    
    // MARK: - Variables
    private var userName: String?
    private var password: String?
    private var confirm: String?
    
    override init() {
        viewType = Dynamic(ProfileViewType.register)
        enableButton = Dynamic(false)
        
        super.init()
        
        if checkIsLogin() {
            viewType = Dynamic(ProfileViewType.profile)
            enableButton.value = checkEnableButton()
        }
    }
    
    var viewType: Dynamic<ProfileViewType>
    var enableButton: Dynamic<Bool>
    
    func updateUserName(inputText: String) {
        userName = inputText
        enableButton.value = checkEnableButton()
    }
    
    func updatePassword(inputText: String) {
        password = inputText
        enableButton.value = checkEnableButton()
    }
    
    func updateConfirm(inputText: String) {
        confirm = inputText
        enableButton.value = checkEnableButton()
    }
    
    func switchLoginRegister() {
        if viewType.value == .login {
            viewType.value = .register
        } else if viewType.value == .register {
            viewType.value = .login
        }
    }
    
    func performRegister() {
        if password != confirm {
            self.errorMessage = "Password & confirm not match!"
            return
        }
        
        let (name, _) = getUserProfile()
        if userName == name {
            self.errorMessage = "Username exist!"
            return
        }
        
        saveUserProfile()
        viewType.value = .profile
    }
    
    func performLogin() {
        if password != confirm {
            self.errorMessage = "Password & confirm not match!"
            return
        }
        
        let (name, pass) = getUserProfile()
        if (userName != name || password != pass) {
            self.errorMessage = "Incorrect username or password!"
            return
        }
        
        saveUserProfile()
        viewType.value = .profile
    }
    
    func performLogout() {
        logOut()
        viewType.value = .login
    }
    
    var onError: ((String) -> ())?
    
    var errorMessage: String = "" {
        didSet {
            onError?(errorMessage)
        }
    }
    
    // MARK: - Private functions
    private func saveUserProfile() {
        let userDefault = UserDefaults.standard
        userDefault.setValue(userName, forKey: USERDEFAULT_KEYS.USER_NAME)
        userDefault.setValue(password, forKey: USERDEFAULT_KEYS.PASSWORD)
        userDefault.setValue(true, forKey: USERDEFAULT_KEYS.IS_LOGIN)
    }
    
    private func getUserProfile() -> (String, String) {
        let userDefault = UserDefaults.standard
        let userName = userDefault.string(forKey: USERDEFAULT_KEYS.USER_NAME) ?? ""
        let password = userDefault.string(forKey: USERDEFAULT_KEYS.PASSWORD) ?? ""
        return (userName, password)
    }
    
    private func checkIsLogin() -> Bool {
        let isLogin = UserDefaults.standard.bool(forKey: USERDEFAULT_KEYS.IS_LOGIN)
        return isLogin
    }
    
    private func logOut() {
        UserDefaults.standard.setValue(nil, forKey: USERDEFAULT_KEYS.IS_LOGIN)
    }
    
    private func checkEnableButton() -> Bool {
        switch viewType.value {
        case .login:
            return (userName != "" && password != "")
        case .register:
            return (userName != "" && password != "" && confirm != "")
        default:
            return true
        }
    }
}
