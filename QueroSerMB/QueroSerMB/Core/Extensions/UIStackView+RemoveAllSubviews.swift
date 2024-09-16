//
//  UIStackView+RemoveAllSubviews.swift
//  QueroSerMB
//
//  Created by Guilherme Prata Costa on 16/09/24.
//

import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            NSLayoutConstraint.deactivate(subview.constraints)
            subview.removeFromSuperview()
            return allSubviews + [subview]
        }
    }
}
