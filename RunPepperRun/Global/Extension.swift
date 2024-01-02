//
//  Extension.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/2/24.
//

import UIKit

extension UIColor {
    func lighter(by percentage: CGFloat = 40.0) -> UIColor? {
        return adjust(by: abs(percentage))
    }
    
    func darker(by percentage: CGFloat = 40.0) -> UIColor? {
        return adjust(by: -1 * abs(percentage))
    }
    
    private func adjust(by percentage: CGFloat) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(
                red: min(red + percentage / 100, 1.0),
                green: min(green + percentage / 100, 1.0),
                blue: min(blue + percentage / 100, 1.0),
                alpha: alpha
            )
        } else {
            return nil
        }
    }
}
