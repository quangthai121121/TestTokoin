//
//  ProfileViewController.swift
//  TestTokoin
//
//  Created by THAI LE QUANG on 9/14/20.
//  Copyright © 2020 Dream. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    @IBOutlet weak var viewRegister: UIView!
    @IBOutlet var tfUserName: UITextField!
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var tfConfirm: UITextField!
    
    @IBOutlet weak var lbUsername: UILabel!
    
    
    @IBOutlet weak var btHasAccount: UIButton!
    @IBOutlet var btRegister: UIButton!
    
    private var viewModel: ProfileViewModel? {
        didSet {
            fillUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)

        viewModel = ProfileViewModelImplement()
    }

    fileprivate func fillUI() {
        guard var viewModel = viewModel else {
            return
        }
        
        viewModel.onError = { [weak self] message in
            self?.showAlertWith(message: message)
        }
        
        viewModel.viewType.bindAndFire { [weak self] (type) in
            guard let wSelf = self else { return }
            
            switch (type) {
            case .login:
                wSelf.title = "Login"
                wSelf.btRegister.setTitle("Login", for: .normal)
                wSelf.btHasAccount.setTitle("Dont have account?", for: .normal)
                wSelf.viewRegister.isHidden = false
                wSelf.tfConfirm.isHidden = true
            case .profile:
                wSelf.title = "Profile"
                wSelf.btRegister.setTitle("Logout", for: .normal)
                wSelf.viewRegister.isHidden = true
                let (username, _) = viewModel.getUserProfile()
                wSelf.lbUsername.text = "Username: " + username
            case .register:
                wSelf.title = "Register"
                wSelf.btRegister.setTitle("Register", for: .normal)
                wSelf.btHasAccount.setTitle("Has account?", for: .normal)
                wSelf.tfConfirm.isHidden = false
                
                
            }
            
            wSelf.tabBarController?.tabBar.items?[2].title = "Profile"
        }
        
        viewModel.enableButton.bindAndFire { [weak self] (enable) in
            self?.btRegister.backgroundColor = enable ? .blue : .lightGray
            self?.btRegister.isEnabled = enable
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func buttonHasAccount_click(_ sender: Any) {
        viewModel?.switchLoginRegister()
    }
    
    @IBAction func buttonRegister_click(_ sender: Any) {
        switch viewModel?.viewType.value {
        case .login:
            viewModel?.performLogin()
        case .register:
            viewModel?.performRegister()
        case .profile:
            viewModel?.performLogout()
        default:
            print("not handle")
        }
    }
}

extension ProfileViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let inputText = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        if textField == tfUserName {
            viewModel?.updateUserName(inputText: inputText)
        } else if textField == tfPassword {
            viewModel?.updatePassword(inputText: inputText)
        } else if textField == tfConfirm {
            viewModel?.updateConfirm(inputText: inputText)
        }

        return true
    }
}
