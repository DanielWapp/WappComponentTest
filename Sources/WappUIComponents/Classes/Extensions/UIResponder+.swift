//
//  UIResponder+.swift
//  
//
//  Created by Daniel on 06.07.23.
//

import Foundation
import UIKit

public extension UIResponder {
    
    func owningViewController() -> UIViewController? {
        var nextResponser = self
        while let next = nextResponser.next {
            nextResponser = next
            if let viewController = nextResponser as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
