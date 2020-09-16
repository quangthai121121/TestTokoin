//
//  ProfileViewModelTest.swift
//  TestTokoinTests
//
//  Created by THAI LE QUANG on 9/16/20.
//  Copyright © 2020 Dream. All rights reserved.
//

@testable import TestTokoin
import XCTest

class ProfileViewModelTest: XCTestCase {

    // MARK :-  Variables
    var viewModel: ProfileViewModel!
    
    // Life cycle
    override func setUp() {
        super.setUp()
        
        // Initializing properties
        viewModel = ProfileViewModelImplement()
    }
    
    // Life cycle
    
    override func tearDown() {
        // Deinitializing propertise
        viewModel = nil
        
        super.tearDown()
    }
    
    // Testing change register to login
    // Expectation is viewtype observer is called and viewtype change to register
    func testChangeViewTypeCalled() {
        let expectation = XCTestExpectation(description: "Change viewtype success")
        
        viewModel.switchLoginRegister()
        
        viewModel.viewType.bindAndFire { (list) in
            XCTAssertTrue(self.viewModel.viewType.value == ProfileViewType.login)
            expectation.fulfill()
        }
    }
    
    // Testing register account
    // Expectation is register success and viewtype observer is called
    
    func testRegisterCalled() {
        let expectation = XCTestExpectation(description: "Register success")
        
        viewModel.updateUserName(inputText: "test")
        viewModel.updatePassword(inputText: "1234")
        viewModel.updateConfirm(inputText: "1234")
        
        viewModel.performRegister()
        
        let (userName, password) = viewModel.getUserProfile()
        let isLogin = viewModel.checkIsLogin()
        
        XCTAssertTrue(userName == "test")
        XCTAssertTrue(password == "1234")
        XCTAssertTrue(isLogin == true)
        
        viewModel.viewType.bindAndFire { [weak self](list) in
            XCTAssertTrue(self?.viewModel.viewType.value == ProfileViewType.profile)
            expectation.fulfill()
        }
    }
    
    // Testing login account
    // Expectation is login success and viewtype observer is called
    
    func testLoginCalled() {
        let expectation = XCTestExpectation(description: "Login success")
        
        viewModel.updateUserName(inputText: "test")
        viewModel.updatePassword(inputText: "1234")
        
        viewModel.performLogin()
        
        let isLogin = viewModel.checkIsLogin()
        XCTAssertTrue(isLogin == true)
        
        viewModel.viewType.bindAndFire { (list) in
            XCTAssertTrue(self.viewModel.viewType.value == ProfileViewType.profile)
            expectation.fulfill()
        }
    }
    
    // Testing logout account
    // Expectation is logout success and viewtype observer is called
    
    func testLogoutCalled() {
        let expectation = XCTestExpectation(description: "Logout success")
        
        
        viewModel.performLogout()
        
        let isLogin = UserDefaults.standard.bool(forKey: USERDEFAULT_KEYS.IS_LOGIN)
        XCTAssertTrue(isLogin == false)
        
        viewModel.viewType.bindAndFire { (list) in
            XCTAssertTrue(self.viewModel.viewType.value == ProfileViewType.login)
            expectation.fulfill()
        }
    }
}
