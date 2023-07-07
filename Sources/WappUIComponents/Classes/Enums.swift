//
//  Enums.swift
//  
//
//  Created by Daniel on 06.07.23.
//

import Foundation
import UIKit

public enum Regex: String {
    case password = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])[A-Za-z0-9.!@#$%^&*+_-]{8,16}$"
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    case website = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
    case number = ".*[0-9]+.*"
    case lowerLetter = ".*[a-z]+.*"
    case upperLetter = ".*[A-Z]+.*"
    case specialLetter = ".*[.!@#$%^&*+_-]+.*"
}

public enum Corners {
    case leftUp
    case leftDown
    case rightUp
    case rightDown
    case up
    case down
    case left
    case right
    case all
    
    var mask : CACornerMask {
        switch self {
        case .leftUp: return [.layerMinXMinYCorner]
        case .leftDown: return [.layerMinXMaxYCorner]
        case .rightUp: return [.layerMaxXMinYCorner]
        case .rightDown: return [.layerMaxXMaxYCorner]
        case .up: return [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .down: return [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .left: return [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        case .right: return [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        case .all: return [.layerMaxXMaxYCorner, .layerMaxXMinYCorner,
                            .layerMinXMaxYCorner, .layerMinXMinYCorner]
        }
    }
}
