//
//  HealthKitAuthManager.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/21/23.
//

import Foundation
import HealthKit

class HealthKitManager {
    
    static let shared = HealthKitManager()
    
    let store = HKHealthStore()
    
    private init() {}
    
    func requestAuthorization() {
        let types: Set<HKSampleType> = [HKObjectType.workoutType(),
                     HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                     HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                     HKObjectType.quantityType(forIdentifier: .runningSpeed)!,
        ]
        
        store.getRequestStatusForAuthorization(toShare: types, read: types, completion: { status, error in
            if status == .shouldRequest || status == .unknown {
                self.store.requestAuthorization(toShare: types, read: types) { success, _ in
                    if !success {
                        return
                    }
                }
            }
        })
    }
}
