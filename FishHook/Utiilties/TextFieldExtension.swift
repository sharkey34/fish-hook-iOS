//
//  TextFieldValidation.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/28/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import Foundation
import UIKit

extension UITextField: UITextFieldDelegate {
    
    open override func awakeFromNib() {
        delegate = self
    }
    
    // Making sure the text is not empty or all spaces
    func isNullOrWhitespace() -> Bool {
        var invalid = true
        if let input = self.text {
            if input.trimmingCharacters(in: .whitespaces).isEmpty == false {
                invalid = false
            }
        }
        return invalid
    }
    
    // Checking if the email entered is valid.
    func isValidEmail() -> Bool {
        if let text = self.text {
            let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
            return predicate.evaluate(with: text)
        } else {
            return false
        }
    }
    
    // Validating the length of the password.
    func isValidPassword() -> Bool {
        if let text = self.text {
              return text.count > 5 ? true : false
        } else {
            return false
        }
    }
    
    // Checking entered text length
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let count = textField.text?.count ?? 0
        
        if range.length + range.location > count {
            return false
        }
        let newText = count + string.count - range.length
        return newText <= 30
    }
}
