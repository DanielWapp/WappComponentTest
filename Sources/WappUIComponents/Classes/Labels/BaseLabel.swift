//
//  File.swift
//  
//
//  Created by Daniel on 06.07.23.
//

import Foundation
import UIKit
import Atributika

@IBDesignable open class BaseLabel : UILabel {
    
    @IBInspectable open var locKey : String?
    @IBInspectable open var setColor : UIColor?
    @IBInspectable open var uppercased : Bool = false
    
    open var style : Style { return Style() }

    open override var text: String? {
        didSet {
            self.txtFormatAll(text: text ?? "", styleTag: style)
        }
    }
    
    init(locKey: String, alignment: NSTextAlignment? = nil) {
        super.init(frame: .zero)
        self.locKey = locKey
        if let alignment = alignment { self.textAlignment = alignment }
        setLayout()
    }
    
    convenience init(text: String, alignment: NSTextAlignment? = nil) {
        self.init(locKey: text, alignment: alignment)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    open override func awakeFromNib() {
        setLayout()
    }
    
    open override func prepareForInterfaceBuilder() {
        setLayout()
    }
    
    open func setLayout() {
        let text = uppercased
        ? NSLocalizedString(locKey ?? "", comment: "").upper
        : NSLocalizedString(locKey ?? "", comment: "")
        self.txtFormatAll(text: text, styleTag: style)
    }
}
