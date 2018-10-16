//
//  ButtonEnablingBehavior.swift
//  Random-User-List
//
//  Created by iMaxiOS on 10/16/18.
//  Copyright © 2018 Oleg Granchenko. All rights reserved.
//

import Foundation
import UIKit

final class ButtonEnablingBehavior: NSObject {
    let textFields: [UITextField]
    
    let onChange: (Bool, String) -> Void
    
    init(textFields: [UITextField], onChange: @escaping (Bool, String) -> Void) {
        self.textFields = textFields
        self.onChange = onChange
        super.init()
        setup()
    }
    
    private func setup() {
        textFields.forEach { textField in
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        onChange(true, "")
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        var enable = true
        for textField in textFields {
            guard let text = textField.text, !text.isEmpty else {
                enable = false
                break
            }
            if textField.placeholder == "Email" {
                guard isValidEmail(email: textField.text) else {
                    enable = false
                    break
                }
            }
            if textField.placeholder == "Phone" {
                guard isValidPhone(phone: textField.text) else {
                    enable = false
                    break
                }
            }
        }
        onChange(enable, textField.placeholder!)
    }
    
    //Validate an email for the right format
    func isValidEmail(email:String?) -> Bool {
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    
    //Validate an email for the right format
    func isValidPhone(phone: String?) -> Bool {
        let regEx = "[0-9]{10,14}"
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: phone)
    }
}
