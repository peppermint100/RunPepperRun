//
//  HistoryManager.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/22/24.
//

import Foundation
import FirebaseFirestore

class HistoryManager {
    static let shared = HistoryManager()
    
    let historyRef = Firestore.firestore().collection(FirestoreCollection.history.rawValue)
    
    func createHistory(_ history: History, completion: ((Bool) -> Void)?) {
        do {
            try historyRef.document().setData(from: history)
            completion?(true)
        } catch {
            print("러닝 내역을 저장하는데 실패했습니다.")
            print(error.localizedDescription)
            print(String(describing: error)) // <- ✅ Use this for debuging!
            completion?(false)
        }
    }
}
