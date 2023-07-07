//
//  BaseModalViewController.swift
//  
//
//  Created by Daniel on 06.07.23.
//

import Foundation
import UIKit

class BaseModalViewController: UIViewController {

    private var owningVC : UIViewController?
    open var blurTintColor : UIColor = .black
    open var shadowColor : UIColor?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        owningVC = (self.owningViewController() as? UINavigationController)?.children.last
        owningVC?.blurThemAll(tintColor: blurTintColor)
        hideKeyboardOnTap()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        owningVC?.allBlurMustDie(shadowColor: shadowColor)
    }
}
