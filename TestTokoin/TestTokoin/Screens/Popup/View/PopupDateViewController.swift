//
//  PopupDateViewController.swift
//  TestTokoin
//
//  Created by THAI LE QUANG on 9/14/20.
//  Copyright © 2020 Dream. All rights reserved.
//

import UIKit

protocol PopupDateViewControllerDelegate: class {
    func didSelect(date: Date)
}

class PopupDateViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var contentDatePicker: UIDatePicker!
    var selectedDate: Date?
    
    weak var delegate: PopupDateViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentDate = Date()

        contentDatePicker.maximumDate = currentDate
        contentDatePicker.minimumDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)
        if selectedDate == nil {
            selectedDate = currentDate
        }
    }
    
    @IBAction func backgroundButton_clicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okButton_clicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.didSelect(date: selectedDate!)
    }
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        selectedDate = contentDatePicker.date
    }
}


extension PopupDateViewController: StoryboardProtocol {
    static func bundle() -> Bundle? {
        return nil
    }
    
    static func storyboardName() -> String {
        return "Main"
    }
}
