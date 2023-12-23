//
//  Extensions.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/18/23.
//

import MapKit

extension CLLocationDistance {
    
    func toKiloMetersString() -> String {
        return String(format: "%.2f km", (self * 0.001))
    }
}

extension CLLocationSpeed {
    func toKilometersPerHourString() -> String {
        return String(format: "%.2f km/h", (self / 3.6))
    }
}

extension Double {
    func toCaloriesString() -> String {
        return String(format: "%.2f cal", self)
    }
}
 
extension TimeInterval {
    
    func toHours() -> Double {
        return self / 3600
    }
    
    func toMinutes() -> Double {
        return self / 60
    }
}
