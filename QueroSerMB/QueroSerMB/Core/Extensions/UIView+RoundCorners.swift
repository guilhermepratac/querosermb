//
//  UIView+RoundCorners.swift
//  QueroSerMB
//
//  Created by Guilherme Prata Costa on 10/09/24.
//

import UIKit

extension UIView {
    /// Arredonda os cantos especificados com o raio definido
    /// - Parameters:
    ///   - corners: Os cantos a serem arredondados (da enum DesignSystem.Corner)
    ///   - radius: O raio do arredondamento (da enum DesignSystem.CornerRadius)
    func roundCorners(_ corners: Corner, radius: CornerRadius) {
        let rectCorners = corners.rectCorner
        let radiusValue = radius.rawValue
        
        if rectCorners == .allCorners {
            self.layer.cornerRadius = radiusValue
            self.layer.masksToBounds = true
        } else {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: rectCorners,
                                    cornerRadii: CGSize(width: radiusValue, height: radiusValue))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
    
    /// Cria uma view circular
    func makeCircular() {
        self.roundCorners(.allCorners, radius: .init(rawValue: CornerRadius.circular(for: self)) ?? .small)
    }
}
