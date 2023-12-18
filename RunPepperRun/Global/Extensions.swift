//
//  Extensions.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/18/23.
//

import MapKit

extension CLLocationDistance {
    
    func toKiloMeters() -> CLLocationDistance {
        return self * 0.001
    }
}
 
extension TimeInterval {
    
    func toHours() -> Double {
        return self / 3600
    }
}
