//
//  PopupKeywordViewController.swift
//  TestTokoin
//
//  Created by THAI LE QUANG on 9/14/20.
//  Copyright © 2020 Dream. All rights reserved.
//

import UIKit

protocol PopupKeywordViewControllerDelegate: class {
    func didSelect(keyword: String)
}

class PopupKeywordViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var contentPickerView: UIPickerView!
    var arrayValue: [String] = ["Bitcoin", "Apple", "Earthquake", "Animal"]
    var selectedValue: String?
    
    weak var delegate: PopupKeywordViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let index = arrayValue.firstIndex(where: { $0 == selectedValue }) {
            contentPickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    @IBAction func backgroundButton_clicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okButton_clicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.didSelect(keyword: selectedValue!)
    }

}

extension PopupKeywordViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayValue.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayValue[row]
    }
}

extension PopupKeywordViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValue = arrayValue[row]
    }
}

extension PopupKeywordViewController: StoryboardProtocol {
    static func bundle() -> Bundle? {
        return nil
    }
    
    static func storyboardName() -> String {
        return "Main"
    }
}
