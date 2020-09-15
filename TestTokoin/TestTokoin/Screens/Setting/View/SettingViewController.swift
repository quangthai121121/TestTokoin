//
//  SettingViewController.swift
//  TestTokoin
//
//  Created by THAI LE QUANG on 9/14/20.
//  Copyright © 2020 Dream. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var lbKeyword: UILabel!
    @IBOutlet var lbFromdate: UILabel!
    
    private var viewModel: SettingViewModel? {
        didSet {
            fillUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Setting"
        
        viewModel = SettingViewModelSetting(withKeyword: "Bitcoin", fromDate: Date())
    }
    
    // MARK: - Private functions
    private func fillUI() {
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.settingModel.bindAndFire { [unowned self] in
            self.lbKeyword.text = $0.keyword
            self.lbFromdate.text = $0.fromDate.toString()
        }
    }
    
    // MARK: - Handle actions
    @IBAction func keywordButton_action(_ sender: Any) {
        guard let modalViewController = PopupKeywordViewController.controllerFromStoryboard() else {
            return
        }
        
        modalViewController.delegate          = self
        modalViewController.modalPresentationStyle = .overFullScreen
        modalViewController.modalTransitionStyle   = .crossDissolve
        modalViewController.selectedValue = viewModel?.settingModel.value.keyword
        
        present(modalViewController, animated: true, completion: nil)
    }
    
    @IBAction func fromdDateButton_action(_ sender: Any) {
        guard let modalViewController = PopupDateViewController.controllerFromStoryboard() else {
            return
        }
        
        modalViewController.delegate          = self
        modalViewController.modalPresentationStyle = .overFullScreen
        modalViewController.modalTransitionStyle   = .crossDissolve
        modalViewController.selectedDate = viewModel?.settingModel.value.fromDate
        
        present(modalViewController, animated: true, completion: nil)
    }
}

extension SettingViewController: PopupKeywordViewControllerDelegate {
    func didSelect(keyword: String) {
        viewModel?.updateKeyword(keyword: keyword)
    }
}

extension SettingViewController: PopupDateViewControllerDelegate {
    func didSelect(date: Date) {
        viewModel?.updateFromDate(date: date)
    }
}
