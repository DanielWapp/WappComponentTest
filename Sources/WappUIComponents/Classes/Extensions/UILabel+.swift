//
//  UILabel+.swift
//  
//
//  Created by Daniel on 06.07.23.
//

import Foundation
import UIKit
import Atributika

public extension UILabel {
    
    var nilOrEmpty : Bool {
        return text?.isEmpty ?? true
    }
    
    func txtFormat(text: String, tags: [Style]) {
        self.attributedText = text.style(tags: tags).attributedString
    }

    func txtFormatAll(text: String, styleTag: Style) {
        self.attributedText = text.styleAll(styleTag).attributedString
    }

    func changeTextWithAnimation(duration: Double = 0.2,
                                 text: String,
                                 styleTag: Style) {
        UIView.animate(withDuration: duration,
                       animations: {
            self.alpha = 0.0
        }, completion: { _ in
            self.attributedText = text.styleAll(styleTag).attributedString
            UIView.animate(withDuration: duration) {
                self.alpha = 1.0
            }
        })
    }

    func changeTextWithAnimation(duration: Double = 0.2,
                                 attributedString: NSAttributedString) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        }, completion: { _ in
            self.attributedText = attributedString
            UIView.animate(withDuration: duration) {
                self.alpha = 1.0
            }
        })
    }

    private func createParagraphAttribute() -> NSParagraphStyle {
        var paragraphStyle: NSMutableParagraphStyle
        guard let style = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle else {
            return NSParagraphStyle()
        }
        paragraphStyle = style
        if let dict = NSDictionary() as? [NSTextTab.OptionKey : Any] {
            paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15, options: dict)]
        }
        paragraphStyle.defaultTabInterval = 15
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.lineSpacing = 3
        paragraphStyle.headIndent = 17
        return paragraphStyle
    }
}
