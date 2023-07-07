//
//  OutlinedTextfield.swift
//  
//
//  Created by Daniel on 06.07.23.
//

import Foundation
import UIKit

@IBDesignable open class OutlinedTextfield: UITextField {
    
    @IBInspectable open var phLocKey : String?
    @IBInspectable open var txtColor : UIColor?
    @IBInspectable open var lblBackColor : UIColor?
    @IBInspectable open var phColor : UIColor = .black
    @IBInspectable open var borderColor : UIColor = .lightGray
    @IBInspectable open var highlightColor : UIColor = .blue
    @IBInspectable open var errorColor : UIColor = .red
    
    open var style : TextStyle { TextStyle() }
    
    let borderLayer = CALayer()
    var padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    var heightConstraint: NSLayoutConstraint?
    
    let phLabel = TextfieldPlaceholder()
    var phFontSize: CGFloat = 18
    var phTopInset: CGFloat = 18
    var phFocusedFontSize: CGFloat = 16
    
    var phTopConstraint: NSLayoutConstraint!
    var phLeadingConstraint: NSLayoutConstraint!
    var phTrailingConstraint: NSLayoutConstraint!
    var phHeightConstraint: NSLayoutConstraint!
    
    open override var placeholder: String? {
        didSet { updatePlaceholder() }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public init(phLocKey: String?, height: CGFloat? = nil) {
        super.init(frame: .zero)
        self.phLocKey = phLocKey
        self.frame.size.height = height ?? 56
        heightConstraint = self.heightAnchor.constraint(equalToConstant: height ?? 56)
        heightConstraint?.isActive = true
        commonInit()
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.width - 42, y: bounds.midY - 16, width: 32, height: 32)
    }
    
    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 8, y: bounds.midY - 16, width: 32, height: 32)
    }
    
    open override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        if result { updatePlaceholderPosition() }
        return result
    }
    
    open override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        if result { updatePlaceholderPosition() }
        return result
    }

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if leftView != nil { padding.left = 48 }
        if rightView != nil { padding.right = 48 }
        self.tintColor = highlightColor
        self.textColor = txtColor ?? style.color
        self.autocorrectionType = .no
    
        updatePlaceholderPosition(animation: false)
        phLabel.backgroundColor = lblBackColor ?? self.backgroundColor
        
        if let phLocKey = phLocKey, placeholder?.isEmpty ?? true {
            self.placeholder = NSLocalizedString(phLocKey, comment: "")
        }
        
        if !(self.text?.isEmpty ?? true) {
            self.animatePlaceholderColor(to: self.highlightColor)
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        borderLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    private func commonInit() {
        borderStyle = .none
        setupLayout()
        setupLayers()
        addPlaceholderLabel()
        updatePlaceholder()
    }
    
    open func setupLayout() {}
    
    private func setupLayers() {
        borderLayer.borderColor = borderColor.cgColor
        borderLayer.borderWidth = 1
        borderLayer.cornerRadius = 4
        self.layer.addSublayer(borderLayer)
    }
    
    private func addPlaceholderLabel() {
        phLabel.translatesAutoresizingMaskIntoConstraints = false
        phLabel.font = font
        addSubview(phLabel)
        
        let font = style.font
        phFontSize = font.pointSize
        phTopInset = (self.frame.height - font.pointSize) / 2
        phFocusedFontSize = phFontSize - 2
        
        phTopConstraint = phLabel.topAnchor
            .constraint(equalTo: topAnchor, constant: phTopInset)
        phLeadingConstraint = phLabel.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: padding.left)
        phTrailingConstraint = phLabel.trailingAnchor
            .constraint(lessThanOrEqualTo: trailingAnchor, constant: -(padding.right*2))
        phHeightConstraint = phLabel.heightAnchor
            .constraint(equalToConstant: phFontSize)
        
        NSLayoutConstraint.activate([
            phTopConstraint,
            phLeadingConstraint,
            phTrailingConstraint,
            phHeightConstraint
        ])
    }
    
    private func updatePlaceholder() {
        if let placeholder = placeholder {
            let attributedPh = NSAttributedString(string: placeholder,
                                                  attributes: [NSAttributedString.Key.foregroundColor: phColor])
            self.phLabel.attributedText = attributedPh
            self.attributedPlaceholder = NSAttributedString(string: "")
        }
    }
    
    func updatePlaceholderPosition(animation: Bool? = nil) {
        if isFirstResponder || !(text?.isEmpty ?? true) {
            phTopConstraint.constant = -(phFocusedFontSize / 2)
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

    func animatePlaceholderColor(to color: UIColor, borderColor: UIColor? = nil,
                                         colorText: Bool? = nil, animation: Bool? = nil) {
        
        let borderWidth : CGFloat = color == highlightColor ? 2 : 1
        
        if animation ?? true {
            UIView.transition(with: phLabel, duration: 0.2, options: .transitionCrossDissolve) {
                self.borderLayer.borderColor = borderColor?.cgColor ?? color.cgColor
                self.borderLayer.borderWidth = borderWidth
                if colorText ?? true { self.phLabel.textColor = color }
            }
        } else {
            self.borderLayer.borderColor = borderColor?.cgColor ?? color.cgColor
            self.borderLayer.borderWidth = borderWidth
            if colorText ?? true { self.phLabel.textColor = color }
        }
    }
    
    func animatePlaceholderFont(to size: CGFloat, animation: Bool? = nil) {
        if animation ?? true {
            UIView.animate(withDuration: 0.2) {
                self.phLabel.font = self.phLabel.font.withSize(size)
            }
        } else {
            self.phLabel.font = self.phLabel.font.withSize(size)
        }
    }
    
    private func errorAnimation() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.1
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 3, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 3, y: self.center.y))
        self.layer.add(animation, forKey: "position")
        
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    
    // MARK: - Public functions
    
    func triggerError(message: String) {
        self.errorAnimation()
        let colorText = !(self.text?.isEmpty ?? true)
        self.animatePlaceholderColor(to: errorColor, colorText: colorText)
    }
}
