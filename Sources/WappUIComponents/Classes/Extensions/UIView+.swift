//
//  UIView+.swift
//  
//
//  Created by Daniel on 06.07.23.
//

import Foundation
import UIKit
import SnapKit
import VisualEffectView

public extension UIView {
    
    var animatedHidden : Bool {
        get {
            self.isHidden
        } set {
            animateView(hidden: newValue)
        }
    }
    
    var semiAnimatedHidden : Bool {
        get {
            self.isHidden
        } set {
            self.isHidden = newValue
            animateView(hidden: newValue)
        }
    }
    
    func addTransition(type: CATransitionType, subType: CATransitionSubtype? = nil, speed: Float? = nil) {
        let transition = CATransition()
        transition.type = type
        transition.subtype = subType
        transition.speed = speed ?? 1
        self.layer.add(transition, forKey: nil)
    }
    
    func addSubviewWithoutAnimation(subview: UIView) {
        self.addSubview(subview)
        subview.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(self)
            make.center.equalTo(self)
        }
    }

    func addSubviewAtIndex(subview: UIView, index: Int) {
        self.insertSubview(subview, at: index)
        subview.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(self)
            make.center.equalTo(self)
        }
    }

    func addSubviewWithAnimation(subview: UIView, animationDuration: Double) {
        self.addSubview(subview)
        subview.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(self)
            make.center.equalTo(self)
        }
        
        UIView.animate(withDuration: animationDuration/3*2, animations: {
            self.alpha = 1
        })
    }

    func removeSubviewsWithAnimation(animationDuration: Double, complete: @escaping () -> Void) {
        UIView.animate(withDuration: animationDuration/3) {
            self.alpha = 0
        } completion: { (_) in
            self.subviews.forEach { $0.removeFromSuperview() }
            complete()
        }
    }
    
    func doOnTap(viewController: UIViewController, action: Selector) {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(
            target: viewController,
            action: action)
        
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }
    
    func addCorner(radius: CGFloat, directions: [Corners]) {
        self.layer.cornerRadius = radius
        var mask = CACornerMask()
        
        directions.forEach { corner in
            mask.update(with: corner.mask)
        }
        self.layer.maskedCorners = mask
    }
    
    func addCorner(radius: CGFloat, direction: [UIRectCorner], rect: CGRect? = nil) {
        var rect = rect ?? self.bounds
        let maskPath = UIBezierPath(roundedRect: rect,
                                    byRoundingCorners: [.topRight, .bottomLeft],
                                    cornerRadii: CGSize(width: radius, height: 0))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }

    func setGradient(colors: [CGColor],
                     angle: Float = 0,
                     width: CGFloat,
                     height: CGFloat,
                     cornerRadius: CGFloat? = nil) {
        let gradientLayerView: UIView = UIView(frame: CGRect(x:0, y: 0, width: width, height: height))
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = gradientLayerView.bounds
        gradient.colors = colors
        gradient.cornerRadius = cornerRadius ?? CGFloat(0.0)
        
        let alpha: Float = angle / 360
        
        let startPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.75) / 2)),
            2
        )
        let startPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0) / 2)),
            2
        )
        let endPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.25) / 2)),
            2
        )
        let endPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0.5) / 2)),
            2
        )
        
        gradient.endPoint = CGPoint(x: CGFloat(endPointX),y: CGFloat(endPointY))
        gradient.startPoint = CGPoint(x: CGFloat(startPointX*3), y: CGFloat(startPointY*3))
        
        gradientLayerView.layer.insertSublayer(gradient, at: 0)
        layer.insertSublayer(gradientLayerView.layer, at: 0)
    }
    
    func setShadow(color: UIColor, offset: CGSize, radius: CGFloat, opacity: Float, cornerRadius: CGFloat? = nil) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        if cornerRadius != nil { self.layer.cornerRadius = cornerRadius! }
    }
    
    func hideWithAnimation(isHidden: Bool, animationDuration: Double) {
        UIView.animate(withDuration: animationDuration) {
            self.isHidden = isHidden
            self.alpha = isHidden ? 0 : 1
        }
    }
    
    func animateView(hidden: Bool) {
        if !hidden {
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 12.0, options: .curveEaseIn, animations: {
                self.isHidden = false
            }, completion: nil)
            
            UIView.animate(withDuration: 0.8, animations: {
                self.alpha = 1
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 0.4) {
                self.alpha = 0
            } completion: { _ in
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 12.0, options: .curveEaseIn, animations: {
                    self.isHidden = true
                }, completion: nil)
            }
        }
    }
    
    func addBlur(radius: CGFloat, color: UIColor, colorTintAlpha: CGFloat) {
        let blur = VisualEffectView()
        self.addSubviewWithoutAnimation(subview: blur)
        blur.colorTint = color
        blur.blurRadius = radius
        blur.colorTintAlpha = colorTintAlpha
        blur.alpha = 1
    }
}
