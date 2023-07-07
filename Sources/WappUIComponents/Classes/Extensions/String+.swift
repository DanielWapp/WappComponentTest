//
//  File.swift
//  
//
//  Created by Daniel on 06.07.23.
//

import Foundation
import UIKit

public extension String {
    
    var trimmed : String? {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    var upper : String {
        return self.uppercased()
    }
    
    var lower : String {
        return self.lowercased()
    }
    
    func replaceX(text: String) -> String {
        return self.replacingOccurrences(of: "{x}", with: text)
    }
    
    func replace(tag: String, text: String) -> String {
        return self.replacingOccurrences(of: "{\(tag)}", with: text)
    }
    
    internal func isValid(_ regexType: Regex) -> Bool {
        let format = "SELF MATCHES %@"
        let pred = NSPredicate(format: format, regexType.rawValue)
        return pred.evaluate(with: self)
    }
        
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        return boundingBox.height
    }
}
