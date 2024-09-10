//
//  Colors.swift
//  QueroSerMB
//
//  Created by Guilherme Prata Costa on 10/09/24.
//

import UIKit

enum Colors {
    case background
    case offBackground
    case textPrimary
    case textSecondary

    var color: UIColor {
        switch self {
        case .background:
            return UIColor(hex: "#121212")
        case .offBackground:
            return UIColor(hex: "#1E1E1E")
        case .textPrimary:
            return UIColor.white
        case .textSecondary:
            return UIColor(hex: "#B3B3B3")
        }
    }
}
