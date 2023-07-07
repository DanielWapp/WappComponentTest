//
//  UIApplication+.swift
//  
//
//  Created by Daniel on 06.07.23.
//

import Foundation
import UIKit

public extension UIApplication {
   
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let viewTag = 3848245

            let keyWindow = UIApplication.shared.connectedScenes
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows.first

            if let statusBar = keyWindow?.viewWithTag(viewTag) {
                return statusBar
            } else {
                
                let height = keyWindow?
                    .windowScene?
                    .statusBarManager?
                    .statusBarFrame ?? .zero
                
                let statusBarView = UIView(frame: height)
                statusBarView.tag = viewTag
                statusBarView.layer.zPosition = 999999

                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
    return nil
    }
    
    class func getTopViewController(base: UIViewController?) -> UIViewController? {
        var baseVC = base
        if base == nil {
            let keyWindow = UIApplication.shared.connectedScenes
                    .compactMap({$0 as? UIWindowScene})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
            baseVC = keyWindow?.rootViewController
        }
        
        if let navigationController = baseVC as? UINavigationController {
            return getTopViewController(base: navigationController.visibleViewController)

        } else if let tabBarController = baseVC as? UITabBarController,
                  let selected = tabBarController.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = baseVC?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return baseVC
    }
}
