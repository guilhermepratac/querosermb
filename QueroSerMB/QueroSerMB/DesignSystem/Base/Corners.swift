//
//  Corners.swift
//  QueroSerMB
//
//  Created by Guilherme Prata Costa on 10/09/24.
//
import UIKit

enum CornerRadius: CGFloat {
    case small = 4
    case medium = 8
    case large = 12
    case extraLarge = 16
    
    // Caso especial para quando queremos um círculo perfeito
    static func circular(for view: UIView) -> CGFloat {
        return min(view.bounds.width, view.bounds.height) / 2
    }
}
    
enum Corner {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case allCorners
    case top
    case bottom
    case left
    case right
    
    var rectCorner: UIRectCorner {
        switch self {
        case .topLeft: return .topLeft
        case .topRight: return .topRight
        case .bottomLeft: return .bottomLeft
        case .bottomRight: return .bottomRight
        case .allCorners: return .allCorners
        case .top: return [.topLeft, .topRight]
        case .bottom: return [.bottomLeft, .bottomRight]
        case .left: return [.topLeft, .bottomLeft]
        case .right: return [.topRight, .bottomRight]
        }
    }
}
