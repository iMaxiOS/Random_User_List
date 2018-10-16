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
    
    let onChange: (Bool) -> Void
    
    init(textFields: [UITextField], onChange: @escaping (Bool) -> Void) {
        self.textFields = textFields
        self.onChange = onChange
        super.init()
        setup()
    }
    
    private func setup() {
        textFields.forEach { textField in
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        onChange(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        var enable = true
        for textField in textFields {
            guard let text = textField.text, !text.isEmpty else {
                enable = false
                break
            }
            if textField.placeholder == "Email" {
                guard textField.isValidEmail(email: textField.text) else {
                    enable = false
                    break
                }
            }
            if textField.placeholder == "Phone number" {
                guard textField.isValidPhone(phone: textField.text) else {
                    enable = false
                    break
                }
            }
            if textField.placeholder == "First name" {
                guard textField.isValidName(name: textField.text) else {
                    enable = false
                    break
                }
            }
        }
        onChange(enable)
    }
}
