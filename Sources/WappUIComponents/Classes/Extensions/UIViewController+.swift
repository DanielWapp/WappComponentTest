//
//  UIViewController+.swift
//  
//
//  Created by Daniel on 06.07.23.
//

import Foundation
import UIKit
import VisualEffectView

public extension UIViewController {
    
    func hideKeyboardOnTap() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func blurThemAll(tintColor: UIColor) {
        let mainBlur = VisualEffectView()
        let navBlur = VisualEffectView()
        let statusBlur = VisualEffectView()

        self.navigationController?.navigationBar.standardAppearance.shadowColor = .clear
        self.navigationController?.navigationBar.scrollEdgeAppearance?.shadowColor = .clear
        
        view.addSubviewWithoutAnimation(subview: mainBlur)
        
        [mainBlur, navBlur, statusBlur].forEach { vwBlur in
            vwBlur.colorTintAlpha = 0
            vwBlur.colorTint = tintColor
            vwBlur.alpha = 0
        }
        
        UIView.animate(withDuration: 0.4) {
            [mainBlur, navBlur, statusBlur].forEach { vwBlur in
                vwBlur.blurRadius = 6
                vwBlur.colorTintAlpha = 0.5
                vwBlur.alpha = 1
            }
        }
    }
    
    func allBlurMustDie(shadowColor: UIColor? = nil) {
        let blurView = findBlurView(view: self.view)
        let navBlur = findBlurView(view: navigationController?.navigationBar)
        let statusBlur = findBlurView(view: UIApplication.shared.statusBarUIView)
        
        UIView.animate(withDuration: 0.4) {
            [blurView, navBlur, statusBlur].forEach { vwBlur in
                vwBlur?.blurRadius = 0
                vwBlur?.colorTintAlpha = 0
                vwBlur?.alpha = 0
            }
        } completion: { _ in
            [blurView, navBlur, statusBlur].forEach { vwBlur in
                self.navigationController?.navigationBar.standardAppearance.shadowColor = shadowColor ?? .gray
                self.navigationController?.navigationBar.scrollEdgeAppearance?.shadowColor = shadowColor ?? .gray
                vwBlur?.removeFromSuperview()
            }
        }
    }
    
    private func findBlurView(view: UIView?) -> VisualEffectView? {
        var blurView : VisualEffectView?
        
        view?.subviews.forEach { subview in
            if subview.isKind(of: VisualEffectView.self) {
                blurView = subview as? VisualEffectView
            }
        }
        return blurView
    }
    
}
