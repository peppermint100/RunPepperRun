//
//  Extension.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/2/24.
//

import UIKit

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    func setTimeToStartOfTheDay() -> Date {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    func setTimeToEndOfTheDay() -> Date {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }
    
    func toMMdd() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
}

extension Double {
    func mpsToKph() -> Double {
        return self * 1000 / 3600
    }
    
    func metersToKilometers() -> Double {
        return self / 1000
    }
    
    func formatDistance() -> String {
        return String(format: "%.1fkm", self.metersToKilometers())
    }
    
    func formatCaloriesBurned() -> String {
        return String(format: "%.2fcal", self)
    }
    
    func formatSpeed() -> String {
        return String(format: "%.2fkm/h", self.mpsToKph())
    }
    
    func formatPace() -> String {
        let minutes = self / 60
        let secondsLeft = self.truncatingRemainder(dividingBy: 60)
        return String(format: "%d'%d\"", Int(minutes), Int(secondsLeft))
    }
    
    func truncatePoint(to: Double) -> Double {
        let digit: Double = pow(10, to)
        return floor(self * digit) / digit
    }
}

extension Int {
    func formatToHHMMSS() -> String {
        let hours = self / 3600
        let secondsLeft = self - (hours * 3600)
        let minutes = secondsLeft / 60
        let seconds = secondsLeft % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

extension TimeInterval {
    func formatToMMSS() -> String {
        let minutes = self / 60
        let seconds = self.truncatingRemainder(dividingBy: 60)
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

extension UIView {
    func drawLightGradientOnTop(tag: String) {
        let gradientLayer = CAGradientLayer()
        var colors: [CGColor] = []
        colors.append(UIColor.white.withAlphaComponent(1).cgColor)
        colors.append(UIColor.white.withAlphaComponent(0).cgColor)
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.2)
        gradientLayer.frame = self.bounds
        gradientLayer.name = tag
        self.layer.addSublayer(gradientLayer)
    }
}

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

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        let ratio = max(widthRatio, heightRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage ?? self
    }
}
