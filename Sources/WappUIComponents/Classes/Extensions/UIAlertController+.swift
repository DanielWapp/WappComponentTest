//
//  UIAlertController+.swift
//  
//
//  Created by Daniel on 06.07.23.
//

import Foundation
import UIKit

public extension UIAlertController {
    
    convenience init(title: String, message: String, cancelActionTitle: String, submitAction: UIAlertAction) {
        self.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        self.addAction(submitAction)
        self.addAction(UIAlertAction(title: cancelActionTitle, style: UIAlertAction.Style.cancel, handler: nil))
    }
    
    convenience init(title: String, message: String, cancelActionTitle: String) {
        self.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        self.addAction(UIAlertAction(title: cancelActionTitle, style: UIAlertAction.Style.cancel, handler: nil))
    }
    
    convenience init(title: String, message: String, cancelAction: UIAlertAction) {
        self.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        self.addAction(cancelAction)
    }
    
    func popUp() {
        let keyWindow = UIApplication.shared.connectedScenes
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(self, animated: true, completion: nil)
        }
    }
}
