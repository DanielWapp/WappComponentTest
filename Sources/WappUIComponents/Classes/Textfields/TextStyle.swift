//
//  TextStyle.swift
//  
//
//  Created by Daniel on 06.07.23.
//

import Foundation
import UIKit

open class TextStyle {
    var font : UIFont = .systemFont(ofSize: 16)
    var color : UIColor = .black
    var kerning : CGFloat = 0
    var spacing : CGFloat = 19.2 / 16
    
    public init() { }
    
    public init(font: UIFont, color: UIColor, kerning: CGFloat, spacing: CGFloat) {
        self.font = font
        self.color = color
        self.kerning = kerning
        self.spacing = spacing
    }
}
