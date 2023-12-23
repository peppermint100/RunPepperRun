//
//  MotionStatus.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/23/23.
//

import Foundation

enum MotionStatus: Double {
    case stationary = 0
    case walking = 3.8
    case running = 10
    
    func met() -> Double {
        return self.rawValue
    }
}
