//
//  InlinedTextfield.swift
//  
//
//  Created by Daniel on 06.07.23.
//

import Foundation
import UIKit

open class InlinedTextfield : OutlinedTextfield {
    
    override func updatePlaceholderPosition(animation: Bool? = nil) {
        if isFirstResponder || !(text?.isEmpty ?? true) {
            phTopConstraint.constant = -(phFocusedFontSize / 2) + 10
            phLeadingConstraint.constant = padding.left - phLabel.leftInset
            phTrailingConstraint.constant = -(padding.right)
            phHeightConstraint.constant = phFocusedFontSize
            
            if animation ?? true {
                UIView.animate(withDuration: 0.2) {
                    self.layoutIfNeeded()
                    self.animatePlaceholderColor(to: self.highlightColor)
                    self.animatePlaceholderFont(to: self.phFocusedFontSize)
                }
            } else {
                self.animatePlaceholderColor(to: self.highlightColor)
                self.animatePlaceholderFont(to: self.phFocusedFontSize)
            }
        } else {
            phTopConstraint.constant = phTopInset
            phLeadingConstraint.constant = padding.left - phLabel.leftInset
            phTrailingConstraint.constant = -(padding.right)
            phHeightConstraint.constant = phFontSize
            
            if animation ?? true {
                UIView.animate(withDuration: 0.2) {
                    self.layoutIfNeeded()
                    self.animatePlaceholderColor(to: self.phColor, borderColor: self.borderColor)
                    self.animatePlaceholderFont(to: self.phFontSize)
                }
            } else {
                self.animatePlaceholderColor(to: self.phColor, borderColor: self.borderColor)
                self.animatePlaceholderFont(to: self.phFontSize)
            }
        }
    }
}
