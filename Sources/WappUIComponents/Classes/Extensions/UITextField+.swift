//
//  UITextfield+.swift
//  
//
//  Created by Daniel on 06.07.23.
//

import Foundation
import UIKit

public extension UITextField {
    
    var nilOrEmpty : Bool {
        guard let text = self.trimmedText else { return true }
        return text.isEmpty
    }

    func isValid(_ regexType: Regex) -> Bool {
        return self.text?.isValid(regexType) ?? false
    }
    
    var trimmedText : String? {
        return self.text?.trimmed
    }
    
//    internal func checkIfEmpty(type: TextfieldMissingError? = nil) -> String? {
//        guard nilOrEmpty else { return self.trimmedText }
//        let type = type ?? .general
//        guard let owningVC = self.owningViewController() else { return nil }
//        SnackBar(info: type.snackInfo, showIn: owningVC).show()
//        return nil
//    }
    
    func addPicker(withTag: Int? = nil,
                   selectSelector: Selector? = nil,
                   doneSelector: Selector? = nil,
                   resetSelector: Selector? = nil,
                   toolBarColor: UIColor? = nil,
                   btnColor: UIColor? = nil) -> UIPickerView {
        let picker = UIPickerView()
        if let pickerTag = withTag {
            picker.tag = pickerTag
        }
        self.inputView = picker
        addToolBar(doneSelector: doneSelector,
                   selectSelector: selectSelector,
                   resetSelector: resetSelector,
                   toolBarColor: toolBarColor,
                   btnColor: btnColor)
        return picker
    }
    
    func addDatePicker(date: Date? = nil, minDate: Date? = nil,
                       maxDate: Date? = nil, tag: Int? = nil,
                       mode: UIDatePicker.Mode, selector: Selector? = nil,
                       toolBarColor: UIColor? = nil, btnColor: UIColor? = nil)
    -> UIDatePicker {
        let picker = UIDatePicker()
        
        if let minDate = minDate {
            picker.minimumDate = minDate
        }
        
        if let maxDate = maxDate {
            picker.maximumDate = maxDate
        }
        
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        picker.datePickerMode = mode
        
        if let tag = tag { picker.tag = tag }
        if let date = date { picker.date = date }
        
        self.inputView = picker
        
        addToolBar(doneSelector: selector,
                   toolBarColor: toolBarColor,
                   btnColor: btnColor)
        
        return picker
    }

    func addToolBar(doneSelector: Selector? = nil,
                    selectSelector : Selector? = nil,
                    resetSelector: Selector? = nil,
                    toolBarColor: UIColor? = nil,
                    btnColor: UIColor? = nil) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.tintColor = toolBarColor ?? .white
        
        let targetDone = doneSelector == nil ? self : self.owningViewController()
        let selectorDone = doneSelector ?? #selector(donePressed)
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("picker_done", comment: ""),
                                         style: UIBarButtonItem.Style.done,
                                         target: targetDone,
                                         action: selectorDone)
        doneButton.tintColor = btnColor ?? .black
        
        var selectButton : UIBarButtonItem?
        if let selectSelector = selectSelector {
            selectButton = UIBarButtonItem(title: NSLocalizedString("picker_select", comment: ""),
                                           style: UIBarButtonItem.Style.done,
                                           target: self.owningViewController,
                                           action: selectSelector)
            selectButton?.tintColor = btnColor ?? .black
        }
        
        var resetButton : UIBarButtonItem?
        if let resetSelector = resetSelector {
            resetButton = UIBarButtonItem(title: NSLocalizedString("picker_reset", comment: ""),
                                          style: UIBarButtonItem.Style.done,
                                          target: self.owningViewController,
                                          action: resetSelector)
            resetButton?.tintColor = btnColor ?? .black
        }
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                          target: nil,
                                          action: nil)
        
        var items = [spaceButton, doneButton]
        if let resetButton = resetButton { items.insert(resetButton, at: 0) }
        if let selectButton = selectButton { items.insert(selectButton, at: 0) }
        
        toolBar.setItems(items, animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        self.inputAccessoryView = toolBar
    }
    
    // MARK: - Actions
    
    @objc func donePressed() {
        self.resignFirstResponder()
    }
}
